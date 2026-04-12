from datetime import datetime
from typing import Dict, List, Tuple

from expense import Expense


def monthly_summary(expenses: List[Expense], year: int, month: int) -> Tuple[float, int]:
    total = 0.0
    count = 0
    for expense in expenses:
        try:
            exp_date = datetime.strptime(expense.date, "%Y-%m-%d")
        except ValueError:
            continue
        if exp_date.year == year and exp_date.month == month:
            total += expense.amount
            count += 1
    return total, count


def category_totals(expenses: List[Expense]) -> Dict[str, float]:
    totals: Dict[str, float] = {}
    for expense in expenses:
        totals[expense.category] = totals.get(expense.category, 0.0) + expense.amount
    return totals


def highest_category(totals: Dict[str, float]) -> Tuple[str, float]:
    if not totals:
        return "", 0.0
    category = max(totals, key=totals.get)
    return category, totals[category]
