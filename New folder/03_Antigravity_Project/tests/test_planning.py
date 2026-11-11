import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))
from agents.planning_analyst import analyze_order
from agents.solution_recommender import recommend_solution

def test_shortage_is_detected():
    order = {"order_id":"T1","product":"Widget","material":"M1",
             "material_required":10,"due_date":"2026-11-01"}
    finding = analyze_order(order, {"M1":4})
    assert finding.shortage_qty == 6
    assert finding.risk == "HIGH"

def test_sufficient_inventory():
    order = {"order_id":"T2","product":"Widget","material":"M1",
             "material_required":10,"due_date":"2026-11-01"}
    finding = analyze_order(order, {"M1":10})
    assert finding.shortage_qty == 0
    assert finding.risk == "LOW"

def test_shortage_requires_human_approval():
    order = {"order_id":"T3","product":"Widget","material":"M1",
             "material_required":10,"due_date":"2026-11-01"}
    finding = analyze_order(order, {"M1":3})
    rec = recommend_solution(finding, {"M1":["M1A"]})
    assert rec["approval_required"] is True
    assert "M1A" in rec["options"][0]
