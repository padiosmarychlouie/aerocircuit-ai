-- ====================================================================
-- Cloudflare D1 SQLite Database Schema
-- Project: AeroCircuit AI - Manufacturing Planning System
-- Purpose: Store client consultation and contact form submissions
-- ====================================================================

-- 1. Client Contacts & Consultation Inquiries Table
CREATE TABLE IF NOT EXISTS contacts (
    id TEXT PRIMARY KEY,                       -- Unique reference ID, e.g. '#INQ-94281'
    name TEXT NOT NULL,                        -- Full Name of client/prospect
    email TEXT NOT NULL,                       -- Work Email address
    company TEXT NOT NULL,                     -- Company or Manufacturing Facility name
    role TEXT,                                 -- Job title / Role (e.g. VP Operations, Chief Planner)
    volume TEXT,                               -- Monthly production volume tier (10k, 25k, 100k, enterprise)
    interests TEXT,                            -- Selected operational interests (JSON array or comma-separated)
    message TEXT,                              -- Project notes / ERP & SMT setup details
    contact_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- Submission date & timestamp
    client_ip TEXT,                            -- Client IP (from cf-connecting-ip header)
    country TEXT,                              -- Client Country (from cf-ipcountry header)
    status TEXT DEFAULT 'NEW',                 -- Workflow status: NEW, CONTACTED, IN_REVIEW, ARCHIVED
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP -- Last status update timestamp
);

-- 2. Performance Indexes for Efficient Queries
CREATE INDEX IF NOT EXISTS idx_contacts_contact_date ON contacts(contact_date DESC);
CREATE INDEX IF NOT EXISTS idx_contacts_email ON contacts(email);
CREATE INDEX IF NOT EXISTS idx_contacts_company ON contacts(company);
CREATE INDEX IF NOT EXISTS idx_contacts_status ON contacts(status);

-- 3. Optional: Production Orders & Planning Run Checks (for Level 2 Agentic Audits)
CREATE TABLE IF NOT EXISTS production_checks (
    id TEXT PRIMARY KEY,
    order_id TEXT NOT NULL,
    product_name TEXT NOT NULL,
    units INTEGER NOT NULL,
    deadline DATE NOT NULL,
    pmic_status TEXT,
    mlcc_inventory INTEGER,
    shift_hours INTEGER,
    dual_sourcing_active INTEGER DEFAULT 0,
    recommendation_summary TEXT,
    check_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_production_checks_order ON production_checks(order_id);
CREATE INDEX IF NOT EXISTS idx_production_checks_date ON production_checks(check_date DESC);

