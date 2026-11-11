# AeroCircuit AI — Electronics Manufacturing Operations Intelligence & Level 2 Agentic Planning

[![Cloudflare Pages](https://img.shields.io/badge/Deployed%20on-Cloudflare%20Pages-f38020?logo=cloudflare&logoColor=white)](https://aerocircuit-ai.pages.dev)
[![Database](https://img.shields.io/badge/Database-Cloudflare%20D1%20SQLite-blue?logo=sqlite&logoColor=white)](https://aerocircuit-ai.pages.dev/solution#contact)
[![Agentic AI](https://img.shields.io/badge/Autonomy-Level%202%20Human--in--the--Loop-emerald)](agents.md)
[![Test Suite](https://img.shields.io/badge/Tests-100%25%20Passing-brightgreen)](test_manufacturing_agent.ps1)

> **Live Production URL**: [https://aerocircuit-ai.pages.dev](https://aerocircuit-ai.pages.dev)  
> **Client Consultation & D1 Form**: [https://aerocircuit-ai.pages.dev/solution#contact](https://aerocircuit-ai.pages.dev/solution#contact)

---

## 📋 Overview

**AeroCircuit AI** is a mission-critical Manufacturing Operations Intelligence and Planning System built with **Level 2 Agentic AI**. It identifies component shortages, balances Surface-Mount Technology (SMT) line workloads, optimizes multimodal freight, and enforces formal **Human-in-the-Loop approval** before committing any changes to the Manufacturing Execution System (MES).

Client consultations and plant pilot inquiry forms are saved directly to an edge-replicated **Cloudflare D1 SQLite Database** with exact submission timestamps (`contact_date`).

---

## 🚀 Key Features

1. **BOM Shortage & Critical Path Detection**:
   - Analyzes real-time Bill of Materials inventories.
   - Traces critical path components (e.g. TPS65987D PMIC) to identify delays before they halt the production floor.
2. **SMT Machine Capacity & Tact Balancing**:
   - Monitors dual-gantry placement engines (Panasonic NPM-D3, Fuji NXT III, ASM Siplace SX2).
   - Dynamically reallocates feeder slots and balances placement cycles across lines.
3. **Multimodal Delivery & Split-Load Logistics**:
   - Compares Standard Air, Express Freight, and Phased Split-Load delivery options.
   - Evaluates cost trade-offs, weight limits, and pallet layouts to meet target deadlines.
4. **Cloudflare D1 SQLite Backend**:
   - Serverless Cloudflare Pages Functions (`/api/contact`).
   - Securely stores client inquiries, plant scale volumes, interests, and contact dates into Cloudflare D1.
   - Built-in live Leads Manager with real-time D1 synchronization and CSV export.
5. **Level 2 Agentic Governance & Human Approval**:
   - Strictly enforces formal Change Request approval from the Chief Operations Planner (Dr. C).
   - Generates SHA-256 tamper-evident verification certificates forMES commit auditing.

---

## 🗄️ Database Architecture (Cloudflare D1 SQLite)

The system utilizes Cloudflare D1 SQLite (`schema.sql`):

```sql
CREATE TABLE IF NOT EXISTS contacts (
    id TEXT PRIMARY KEY,                       -- e.g. '#INQ-94281'
    name TEXT NOT NULL,                        -- Client Name
    email TEXT NOT NULL,                       -- Work Email
    company TEXT NOT NULL,                     -- Facility / Company
    role TEXT,                                 -- Operations Role
    volume TEXT,                               -- Production Volume Tier
    interests TEXT,                            -- Operational Interests (JSON)
    message TEXT,                              -- Facility Notes & Setup
    contact_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- Submission Date
    client_ip TEXT,                            -- Cloudflare CF-Connecting-IP
    country TEXT,                              -- Cloudflare CF-IPCountry
    status TEXT DEFAULT 'NEW',                 -- Workflow Status
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_contacts_contact_date ON contacts(contact_date DESC);
CREATE INDEX IF NOT EXISTS idx_contacts_email ON contacts(email);
```

---

## 🧪 Testing & Validation

The project includes two comprehensive test suites with **100% pass rates**:

1. **Cloudflare D1 Integration Test Suite** (`test_d1_integration.ps1`):
   - 35 automated checks verifying schema integrity, contact date formatting, Cloudflare Pages functions, CORS headers, and local D1 emulation.
2. **Manufacturing Planning Agent Test Suite** (`test_manufacturing_agent.ps1`):
   - 41 automated checks validating mathematical throughput calculations, zero hardcoded API keys, #PO-94281 specs, and failure handling rules.

To run the tests:
```powershell
powershell -ExecutionPolicy Bypass -File .\test_d1_integration.ps1
powershell -ExecutionPolicy Bypass -File .\test_manufacturing_agent.ps1
```

---

## 💻 Local Development

Run the lightweight local planning server (with built-in D1 SQLite emulation):
```powershell
powershell -File .\server.ps1 -Port 8080
```
Open [http://localhost:8080](http://localhost:8080) in your browser.

---

## 🚢 Deployment to Cloudflare

Deploying to Cloudflare Pages:
```powershell
.\deploy_to_cloudflare.bat
```
Or with Wrangler CLI:
```bash
npx wrangler pages deploy dist --project-name aerocircuit-ai
```

---

## 📄 License & Specifications
- Specification: [agents.md](agents.md)
- Solution Design: [DESIGN.md](DESIGN.md)
