from dataclasses import dataclass

@dataclass
class Finding:
    order_id: str
    product: str
    required_material: str
    required_qty: int
    available_qty: int
    shortage_qty: int
    due_date: str
    risk: str
    explanation: str

def analyze_order(order: dict, inventory: dict) -> Finding:
    """Agent 1: compare material requirements with available inventory."""
    material = order["material"]
    required = int(order["material_required"])
    available = int(inventory.get(material, 0))
    shortage = max(required - available, 0)
    risk = "HIGH" if shortage > 0 else "LOW"
    explanation = (
        f"{shortage} units short of {material}; due date is {order['due_date']}."
        if shortage else f"Inventory covers the required {material} for this order."
    )
    return Finding(
        order_id=order["order_id"],
        product=order["product"],
        required_material=material,
        required_qty=required,
        available_qty=available,
        shortage_qty=shortage,
        due_date=order["due_date"],
        risk=risk,
        explanation=explanation,
    )
