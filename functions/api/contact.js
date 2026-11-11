// ====================================================================
// Cloudflare Pages Function: /api/contact
// Project: AeroCircuit AI - Manufacturing Planning System
// Purpose: Receives client consultation form submissions and persists
//          contact data and timestamp to Cloudflare D1 SQLite Database.
// ====================================================================

const CORS_HEADERS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization, X-Requested-With",
  "Access-Control-Max-Age": "86400",
};

/**
 * Handle CORS Preflight requests
 */
export async function onRequestOptions() {
  return new Response(null, {
    status: 204,
    headers: CORS_HEADERS,
  });
}

/**
 * Helper to get D1 database binding
 */
function getDatabase(env) {
  return env.DB || env.DATABASE || env.aerocircuit_contacts || env.D1;
}

/**
 * Auto-initialize D1 SQLite table if not already created
 */
async function ensureTableExists(db) {
  const initSql = `
    CREATE TABLE IF NOT EXISTS contacts (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      email TEXT NOT NULL,
      company TEXT NOT NULL,
      role TEXT,
      volume TEXT,
      interests TEXT,
      message TEXT,
      contact_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      client_ip TEXT,
      country TEXT,
      status TEXT DEFAULT 'NEW',
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );
    CREATE INDEX IF NOT EXISTS idx_contacts_contact_date ON contacts(contact_date DESC);
    CREATE INDEX IF NOT EXISTS idx_contacts_email ON contacts(email);
  `;
  try {
    // D1 allows batch execution of multiple statements
    if (typeof db.exec === 'function') {
      await db.exec(initSql);
    } else {
      await db.prepare(`
        CREATE TABLE IF NOT EXISTS contacts (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          email TEXT NOT NULL,
          company TEXT NOT NULL,
          role TEXT,
          volume TEXT,
          interests TEXT,
          message TEXT,
          contact_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
          client_ip TEXT,
          country TEXT,
          status TEXT DEFAULT 'NEW',
          updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
        )
      `).run();
    }
  } catch (err) {
    console.warn("Table initialization notice:", err.message);
  }
}

/**
 * POST /api/contact
 * Saves a filled-in client consultation / contact form submission into Cloudflare D1 SQLite
 */
export async function onRequestPost(context) {
  const { request, env } = context;

  try {
    const db = getDatabase(env);

    if (!db) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "Cloudflare D1 Database binding 'DB' is not configured.",
          hint: "Bind your D1 database to the 'DB' variable in Cloudflare Pages Settings -> Functions -> D1 Database Bindings, or in wrangler.toml.",
          storage: "missing_binding"
        }),
        {
          status: 503,
          headers: { ...CORS_HEADERS, "Content-Type": "application/json" }
        }
      );
    }

    // Ensure database table exists
    await ensureTableExists(db);

    // Parse incoming payload
    const body = await request.json().catch(() => ({}));

    const name = (body.name || "").trim();
    const email = (body.email || "").trim();
    const company = (body.company || "").trim();
    const role = (body.role || "").trim();
    const volume = (body.volume || "25k").trim();
    const message = (body.message || "").trim();

    // Validate mandatory fields
    if (!name || !email || !company) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "Validation failed: 'name', 'email', and 'company' are required fields."
        }),
        {
          status: 400,
          headers: { ...CORS_HEADERS, "Content-Type": "application/json" }
        }
      );
    }

    // Format interests as JSON string
    let interestsJson = "[]";
    if (Array.isArray(body.interests)) {
      interestsJson = JSON.stringify(body.interests);
    } else if (typeof body.interests === "string" && body.interests) {
      interestsJson = JSON.stringify([body.interests]);
    }

    // Assign reference ID and contact date
    const id = body.id && body.id.startsWith("#INQ-")
      ? body.id
      : "#INQ-" + Math.floor(10000 + Math.random() * 90000);

    const contactDate = body.timestamp || body.contact_date || new Date().toISOString();
    const clientIp = request.headers.get("cf-connecting-ip") || request.headers.get("x-real-ip") || "unknown";
    const country = request.headers.get("cf-ipcountry") || "unknown";
    const status = "NEW";

    // Insert into Cloudflare D1 SQLite Database
    const statement = db.prepare(`
      INSERT INTO contacts (id, name, email, company, role, volume, interests, message, contact_date, client_ip, country, status)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `);

    await statement.bind(
      id,
      name,
      email,
      company,
      role,
      volume,
      interestsJson,
      message,
      contactDate,
      clientIp,
      country,
      status
    ).run();

    return new Response(
      JSON.stringify({
        success: true,
        message: "Contact inquiry successfully stored in Cloudflare D1 SQLite database.",
        id: id,
        contact_date: contactDate,
        record: {
          id,
          name,
          email,
          company,
          role,
          volume,
          interests: JSON.parse(interestsJson),
          message,
          contact_date: contactDate,
          client_ip: clientIp,
          country: country,
          status: status
        },
        storage: "cloudflare_d1_sqlite"
      }),
      {
        status: 201,
        headers: { ...CORS_HEADERS, "Content-Type": "application/json" }
      }
    );

  } catch (err) {
    console.error("D1 SQLite Insert Error:", err);
    return new Response(
      JSON.stringify({
        success: false,
        error: "Internal database write error: " + (err.message || String(err)),
        storage: "cloudflare_d1_error"
      }),
      {
        status: 500,
        headers: { ...CORS_HEADERS, "Content-Type": "application/json" }
      }
    );
  }
}

/**
 * GET /api/contact
 * Fetches recent client consultation inquiries from Cloudflare D1 SQLite
 */
export async function onRequestGet(context) {
  const { env } = context;

  try {
    const db = getDatabase(env);

    if (!db) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "Cloudflare D1 Database binding 'DB' is not configured.",
          contacts: [],
          storage: "missing_binding"
        }),
        {
          status: 503,
          headers: { ...CORS_HEADERS, "Content-Type": "application/json" }
        }
      );
    }

    await ensureTableExists(db);

    const query = `
      SELECT id, name, email, company, role, volume, interests, message, contact_date, client_ip, country, status
      FROM contacts
      ORDER BY contact_date DESC
      LIMIT 100
    `;

    const { results } = await db.prepare(query).all();

    const formattedContacts = (results || []).map(r => {
      let parsedInterests = [];
      try {
        parsedInterests = JSON.parse(r.interests);
      } catch (e) {
        parsedInterests = r.interests ? [r.interests] : [];
      }
      return {
        ...r,
        timestamp: r.contact_date, // backward compatibility
        interests: parsedInterests
      };
    });

    return new Response(
      JSON.stringify({
        success: true,
        total: formattedContacts.length,
        contacts: formattedContacts,
        storage: "cloudflare_d1_sqlite"
      }),
      {
        status: 200,
        headers: {
          ...CORS_HEADERS,
          "Content-Type": "application/json",
          "Cache-Control": "no-store, no-cache, must-revalidate"
        }
      }
    );

  } catch (err) {
    console.error("D1 SQLite Query Error:", err);
    return new Response(
      JSON.stringify({
        success: false,
        error: "Database query error: " + (err.message || String(err)),
        contacts: [],
        storage: "cloudflare_d1_error"
      }),
      {
        status: 500,
        headers: { ...CORS_HEADERS, "Content-Type": "application/json" }
      }
    );
  }
}

