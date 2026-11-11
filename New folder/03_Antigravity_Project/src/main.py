from agents.planning_analyst import analyze_order
from agents.solution_recommender import recommend_solution
from tools.sample_data import ORDERS, INVENTORY, APPROVED_SUBSTITUTES

def run_workflow():
    print("\\nMANUFACTURING PLANNING AND LOAD MANAGEMENT — DEMO")
    print("Sample data only. No production systems are changed.\\n")
    findings = []
    for order in ORDERS:
        finding = analyze_order(order, INVENTORY)
        recommendation = recommend_solution(finding, APPROVED_SUBSTITUTES)
        findings.append((finding, recommendation))
        print(f"Order: {finding.order_id} | Product: {finding.product}")
        print(f"Risk: {finding.risk} | {finding.explanation}")
        print("Suggested next steps:")
        for i, option in enumerate(recommendation["options"], 1):
            print(f"  {i}. {option}")
        if recommendation["approval_required"]:
            print("HUMAN CHECKPOINT: planner approval is required before any action.")
            choice = input("Planner decision [approve/reject/review]: ").strip().lower()
            if choice == "approve":
                print("Recorded as approved for follow-up by the planner; no system changes made.")
            elif choice == "reject":
                print("Recommendation rejected by planner.")
            else:
                print("Sent for further human review.")
        else:
            print("No shortage detected in this sample.")
        print("-" * 62)
    return findings

if __name__ == "__main__":
    run_workflow()
