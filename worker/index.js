// ====================================================================
// Cloudflare Worker / Advanced Pages Worker: Contact Form & D1 Handler
// Project: AeroCircuit AI - Manufacturing Planning System
// ====================================================================

const CORS_HEADERS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization, X-Requested-With",
  "Access-Control-Max-Age": "86400",
};

export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);

    // Handle CORS preflight
    if (request.method === "OPTIONS") {
      return new Response(null, { status: 204, headers: CORS_HEADERS });
    }

    // Route: /api/contact or /api/contacts
    if (url.pathname === "/api/contact" || url.pathname === "/api/contacts") {
      const db = env.DB || env.DATABASE || env.aerocircuit_contacts;

      if (!db) {
        return new Response(
          JSON.stringify({
            success: false,
            error: "D1 database binding 'DB' not configured.",
            storage: "missing_binding"
          }),
          { status: 503, headers: { ...CORS_HEADERS, "Content-Type": "application/json" } }
        );
      }

      // Auto ensure table exists
      try {
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
      } catch (e) {
        console.warn("Table check warning:", e.message);
      }

      // POST: Save new contact data
      if (request.method === "POST") {
        try {
          const body = await request.json();
          const name = (body.name || "").trim();
          const email = (body.email || "").trim();
          const company = (body.company || "").trim();
          const role = (body.role || "").trim();
          const volume = (body.volume || "25k").trim();
          const message = (body.message || "").trim();

          if (!name || !email || !company) {
            return new Response(
              JSON.stringify({ success: false, error: "name, email, and company are required." }),
              { status: 400, headers: { ...CORS_HEADERS, "Content-Type": "application/json" } }
            );
          }

          let interestsJson = "[]";
          if (Array.isArray(body.interests)) {
            interestsJson = JSON.stringify(body.interests);
          } else if (typeof body.interests === "string" && body.interests) {
            interestsJson = JSON.stringify([body.interests]);
          }

          const id = body.id && body.id.startsWith("#INQ-")
            ? body.id
            : "#INQ-" + Math.floor(10000 + Math.random() * 90000);

          const contactDate = body.timestamp || body.contact_date || new Date().toISOString();
          const clientIp = request.headers.get("cf-connecting-ip") || "unknown";
          const country = request.headers.get("cf-ipcountry") || "unknown";

          await db.prepare(`
            INSERT INTO contacts (id, name, email, company, role, volume, interests, message, contact_date, client_ip, country, status)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
          `).bind(
            id, name, email, company, role, volume, interestsJson, message, contactDate, clientIp, country, "NEW"
          ).run();

          return new Response(
            JSON.stringify({
              success: true,
              message: "Saved to Cloudflare D1 SQLite database.",
              id: id,
              contact_date: contactDate,
              storage: "cloudflare_d1_sqlite"
            }),
            { status: 201, headers: { ...CORS_HEADERS, "Content-Type": "application/json" } }
          );
        } catch (err) {
          return new Response(
            JSON.stringify({ success: false, error: err.message }),
            { status: 500, headers: { ...CORS_HEADERS, "Content-Type": "application/json" } }
          );
        }
      }

      // GET: Retrieve contacts
      if (request.method === "GET") {
        try {
          const { results } = await db.prepare(
            `SELECT id, name, email, company, role, volume, interests, message, contact_date, client_ip, country, status 
             FROM contacts ORDER BY contact_date DESC LIMIT 100`
          ).all();

          const formatted = (results || []).map(r => {
            let parsedInterests = [];
            try { parsedInterests = JSON.parse(r.interests); } catch (e) { parsedInterests = r.interests ? [r.interests] : []; }
            return { ...r, timestamp: r.contact_date, interests: parsedInterests };
          });

          return new Response(
            JSON.stringify({ success: true, total: formatted.length, contacts: formatted, storage: "cloudflare_d1_sqlite" }),
            { status: 200, headers: { ...CORS_HEADERS, "Content-Type": "application/json", "Cache-Control": "no-store" } }
          );
        } catch (err) {
          return new Response(
            JSON.stringify({ success: false, error: err.message, contacts: [] }),
            { status: 500, headers: { ...CORS_HEADERS, "Content-Type": "application/json" } }
          );
        }
      }
    }

    // Fallback: If deployed as Pages Worker, pass through to static asset fetcher if present
    if (env.ASSETS && typeof env.ASSETS.fetch === "function") {
      return env.ASSETS.fetch(request);
    }

    return new Response("Not Found", { status: 404 });
  }
};

