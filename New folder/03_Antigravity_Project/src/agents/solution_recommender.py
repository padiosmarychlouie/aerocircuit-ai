def recommend_solution(finding, approved_substitutes: dict) -> dict:
    """Agent 2: prepare options; never changes inventory or the production schedule."""
    options = []
    if finding.shortage_qty == 0:
        options.append("Proceed with the current plan; inventory appears sufficient.")
    else:
        substitutes = approved_substitutes.get(finding.required_material, [])
        if substitutes:
            options.append(
                "Ask the materials/quality team to confirm availability of an approved "
                f"substitute: {', '.join(substitutes)}."
            )
        options.append("Ask the planner to assess a schedule adjustment or partial production.")
        options.append("Confirm supplier replenishment timing before committing to a revised plan.")
    return {
        "order_id": finding.order_id,
        "risk": finding.risk,
        "shortage_qty": finding.shortage_qty,
        "options": options,
        "approval_required": finding.shortage_qty > 0,
        "notice": "Recommendations only. A qualified human must verify and approve actions."
    }
