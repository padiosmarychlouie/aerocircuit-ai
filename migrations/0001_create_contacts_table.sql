-- Migration 0001: Create contacts table in Cloudflare D1 SQLite
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
CREATE INDEX IF NOT EXISTS idx_contacts_company ON contacts(company);
CREATE INDEX IF NOT EXISTS idx_contacts_status ON contacts(status);

