---
name: Precision Engineering Operations Intelligence
colors:
  surface: '#f8f9ff'
  surface-dim: '#cbdbf5'
  surface-bright: '#f8f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#eff4ff'
  surface-container: '#e5eeff'
  surface-container-high: '#dce9ff'
  surface-container-highest: '#d3e4fe'
  on-surface: '#0b1c30'
  on-surface-variant: '#444653'
  inverse-surface: '#213145'
  inverse-on-surface: '#eaf1ff'
  outline: '#757684'
  outline-variant: '#c4c5d5'
  surface-tint: '#3755c3'
  primary: '#00288e'
  on-primary: '#ffffff'
  primary-container: '#1e40af'
  on-primary-container: '#a8b8ff'
  inverse-primary: '#b8c4ff'
  secondary: '#565e74'
  on-secondary: '#ffffff'
  secondary-container: '#dae2fd'
  on-secondary-container: '#5c647a'
  tertiary: '#003d28'
  on-tertiary: '#ffffff'
  tertiary-container: '#00563a'
  on-tertiary-container: '#5bcf9e'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#dde1ff'
  primary-fixed-dim: '#b8c4ff'
  on-primary-fixed: '#001453'
  on-primary-fixed-variant: '#173bab'
  secondary-fixed: '#dae2fd'
  secondary-fixed-dim: '#bec6e0'
  on-secondary-fixed: '#131b2e'
  on-secondary-fixed-variant: '#3f465c'
  tertiary-fixed: '#85f8c4'
  tertiary-fixed-dim: '#68dba9'
  on-tertiary-fixed: '#002114'
  on-tertiary-fixed-variant: '#005137'
  background: '#f8f9ff'
  on-background: '#0b1c30'
  surface-variant: '#d3e4fe'
typography:
  display-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: -0.015em
  headline-md:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 24px
    letterSpacing: -0.005em
  body-lg:
    fontFamily: Inter
    fontSize: 15px
    fontWeight: '400'
    lineHeight: 22px
  body-md:
    fontFamily: Inter
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 18px
  body-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 14px
    letterSpacing: 0.04em
  code-md:
    fontFamily: JetBrains Mono
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
  code-sm:
    fontFamily: JetBrains Mono
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 14px
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-dense: 0.5rem
  margin: 1.5rem
  margin-compact: 1rem
  space-2xs: 0.125rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 0.75rem
  space-lg: 1rem
  space-xl: 1.5rem
  space-2xl: 2rem
---

## Brand & Style

This design system delivers an institutional, mission-critical workspace tailored for electronics manufacturing operations, supply chain logistics, and AI-driven production telemetry. The aesthetic balances deep industrial competence with the speed and responsiveness of predictive intelligence. 

The visual style is **Corporate / Modern** elevated by engineering precision:
- **Tone & Mood:** Authoritative, calm under stress, uncompromisingly legible, and deterministic. It eliminates decorative flourishes in favor of structural clarity, high information density, and unambiguous state signifiers.
- **Visual Structure:** Rooted in clean planar containers, high-contrast crisp division lines, dark slate top-level framing for executive context, and clear compartmentalization suitable for complex Bill of Materials (BOM), multi-tier assembly Gantt views, and nested component lifecycles.
- **AI Integration:** Operational AI interactions present as structured, auditable intelligence cards embedded directly inside workflows rather than generic conversational bubbles. Machine suggestions display deterministic confidence metrics, source ERP telemetry, and immediate physical line actions.

## Colors

The palette balances institutional aerospace/industrial authority with rigorous data visualization requirements:

- **Primary (`#1E40AF` - Industrial Cobalt):** Core interactive focal point, primary actions, active table row selections, focused states, and high-priority execution controls. Secondary interactive accents leverage `#2563EB` for hover feedback.
- **Secondary (`#0F172A` - Deep Industrial Slate):** The bedrock of application infrastructure. Powers global application headers, primary navigation sidebars, high-level line identifiers, and grounding structural chrome.
- **Status & Telemetry:**
  - **Success / On-Schedule (`#059669`):** Indicates verified QA, on-time component arrivals, nominal machine operational parameters, and cleared logistics runs.
  - **Warning / Lead-Time Risk (`#D97706`):** Highlights buffer erosion, component shortages, extended port wait times, and thermal/yield variances requiring engineer review.
  - **Critical / Line Halted (`#DC2626`):** Reserved strictly for yield collapse, machine down status, hard delivery failures, and blocking validation errors.
- **Surfaces & Neutrals:**
  - **Canvas Background:** `#F8FAFC` (Slate 50) and `#F1F5F9` (Slate 100) maintain an optical baseline that prevents eye fatigue across 12-hour shifts.
  - **Card / Surface:** `#FFFFFF` with razor-sharp `#E2E8F0` structural perimeter borders.
  - **Text Hierarchy:** Primary labels and operational telemetry rest at `#0F172A` (Slate 900); metadata, secondary specs, and schema keys rest at `#475569` (Slate 600) and `#64748B` (Slate 500).

## Typography

Typography prioritizes compact vertical cadence and unambiguous character differentiation. All numerical metrics, component part IDs (e.g., MPN, SKU), yield percentages, batch identifiers, and machine clock rates leverage tabular figures.

- **Primary Sans (`Inter`):** Applied across all structural hierarchy levels, summaries, operational directives, and control components. Tight letter-spacing ensures headers stay cohesive even when packed into dense horizontal data strips.
- **Monospaced Accent (`JetBrains Mono`):** Applied strictly to functional engineering tokens: reel positions, PCB layer indices, lead times (`14d 06h`), serial hex hashes, and IP addresses. 
- **Scale Compactness:** Base desktop line items rely on `body-md` (13px/18px) to optimize row scan speed across expansive 1,000+ line item BOM grids without horizontal clipping.

## Layout & Spacing

The layout is built upon an ultra-stable, deterministic **Fluid 12-Column Grid** tailored for multi-monitor workstation displays (1920x1080 through 4K ultrawide), with dedicated scaling tiers for tablet shop-floor terminals:

- **Layout Structure:**
  - **Application Shell:** Fixed 48px global slate utility bar at the top, accompanied by a collapsable 240px navigation dock on the left.
  - **Telemetry Canvas:** Flexible content viewport supporting multi-panel tiling. Modules default to 16px (`space-lg`) gap distribution, shrinking to 8px (`gutter-dense`) in compact operations mode.
- **Responsive Adaptation:**
  - **Desktop / Workstation (>= 1280px):** 12 columns, 16px gutters, 24px outer margins. Data tables render full parametric sets without collapsed columns.
  - **Tablet / Industrial Terminal (768px - 1279px):** 8 columns, 12px gutters, 16px outer margins. Collateral inspector panels collapse into right slide-over drawers; tables switch non-essential telemetry to expandable row details.
  - **Mobile / Field Device (< 768px):** 4 columns, 8px gutters, 12px outer margins. Single-stream task list format; timeline Gantts convert to chronological vertical step lists.

## Elevation & Depth

To maximize cognitive endurance and retain sharp boundary contrast under high ambient factory floor lighting, the design system minimizes heavy diffuse drop shadows in favor of **Crisp Structural Borders and Tonal Surface Tiers**:

- **Layer 0 (Base Floor):** `#F8FAFC` — Canvas floor and backing backdrop.
- **Layer 1 (Standard Card / Panel):** `#FFFFFF` bordered by a clean `1px solid #E2E8F0`. No shadow; structural containment is established entirely via line edge precision.
- **Layer 2 (Interactive Floating / Dropdowns / Popovers):** `#FFFFFF` bordered by `1px solid #CBD5E1` with an ambient engineering drop: `box-shadow: 0 4px 6px -1px rgba(15, 23, 42, 0.08), 0 2px 4px -2px rgba(15, 23, 42, 0.04)`.
- **Layer 3 (Modal Alerts / Override Dialogs):** `#FFFFFF` bordered by `1px solid #94A3B8` backed by an industrial slate backdrop scrim (`#0F172A` at 60% opacity) and elevated with: `box-shadow: 0 20px 25px -5px rgba(15, 23, 42, 0.15), 0 8px 10px -6px rgba(15, 23, 42, 0.08)`.
- **Active Focus Elevation:** Interactive cells and input fields never rely on drop shadows alone; they employ a sharp `2px` offset ring in `#1E40AF`.

## Shapes

The shape system is set to **Level 1 (Soft)**, reflecting strict industrial tooling and precision mechanics:

- **Component Controls:** Input fields, dropdown triggers, and buttons use an exact corner radius of `4px` (`0.25rem`). This preserves maximum screen real estate and ensures horizontal alignment with dense data cells.
- **Surface Containers:** Cards, analytical modules, modal frames, and chat cards utilize `8px` (`0.5rem` / `rounded-lg`).
- **Telemetry Chips & Badges:** Feature a tight `4px` (`0.25rem`) radius rather than circular pills, maintaining a calibrated, technical appearance.
- **Dividers:** 1px hairline rules without feathering or blur, using `#E2E8F0` on white and `#334155` on slate headers.

## Components

### Buttons
- **Primary:** High-density cobalt background (`#1E40AF`), crisp 4px radius, white text (`Inter` 13px Semibold), 8px horizontal padding, 6px vertical padding. Active state transitions to `#1E3A8A`.
- **Secondary / Outline:** Pure white background, `1px solid #CBD5E1`, text `#0F172A`. Hover transitions to `#F8FAFC` background and `#94A3B8` border.
- **Destructive:** Bordered or solid `#DC2626` with pure white text, reserved exclusively for irreversible actions (e.g., abort batch, purge run).

### High-Density Data Tables (BOM & Inventory)
- **Header Cells:** Background `#F8FAFC`, uppercase `Inter` 11px bold, tracking 0.04em, color `#64748B`, vertical height fixed at 32px, `1px solid #E2E8F0` bottom boundary.
- **Row Specs:** Fixed 36px line height for dense packing. Row divider `1px solid #F1F5F9`. Alternating row highlight `#FAFAFA` optional.
- **Cell Alignment:** Left-aligned for text/part names; right-aligned for lead-times, quantities, unit prices; center-aligned for binary flags and single-character status icons. All numerical and ID columns enforce `JetBrains Mono`.

### Chips & Badges
- **Specification:** Height 20px, radius 4px, uppercase `Inter` 10px/11px font weight 700 with tabular metrics.
- **Success Chip:** `#ECFDF5` background, `#047857` label, `#A7F3D0` perimeter stroke.
- **Warning Chip:** `#FFFBEB` background, `#B45309` label, `#FDE68A` perimeter stroke.
- **Critical Chip:** `#FEF2F2` background, `#B91C1C` label, `#FECACA` perimeter stroke.
- **Neutral Part / Rev Tag:** `#F1F5F9` background, `#334155` text, font `JetBrains Mono`.

### Interactive AI Operations Cards
- Embedded within supply chain assistant dialogues and automated line monitors:
- **Card Framing:** White surface, `1px solid #CBD5E1`, top accent border of 3px solid `#1E40AF`.
- **Header:** Displays the AI confidence score badge (e.g., `CONFIDENCE: 98.4%`), the trigger time, and affected MPN.
- **Body Data:** Two-column grid comparing *Current ERP Schedule* vs. *AI Suggested Re-Route*. Data points rendered in `JetBrains Mono`.
- **Action Strip:** Horizontal dock housing an immediate single-click action: "Authorize Purchase Order" (Primary Button) and "Simulate Buffer Impact" (Secondary Button).

### Gantt & Milestone Timeline Indicators
- Continuous horizontal 2px background rule in `#E2E8F0`.
- **Milestone Nodes:** 12x12px square nodes with 2px radius. Completed milestones use `#059669`; active/in-progress nodes pulse with a 2px ring of `#1E40AF`; late/delayed dependencies display `#D97706`.
- **Tooltip Hover:** Immediate, un-animated popover displaying step duration in `JetBrains Mono`, assigned SMT line, and vendor contingency delta.

### Inputs & Selectors
- Background `#FFFFFF`, height 32px, `1px solid #CBD5E1`, 4px radius, font 13px `Inter`. Focus state utilizes `border-color: #1E40AF` with a non-blurring `0 0 0 1px #1E40AF` outline. Monospace inputs applied automatically for serial and part search fields.