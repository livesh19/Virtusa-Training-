import csv
import os
from typing import List

from expense import Expense

FIELDNAMES = ["date", "category", "amount", "description"]


def ensure_storage(file_path: str) -> None:
    os.makedirs(os.path.dirname(file_path), exist_ok=True)
    if not os.path.exists(file_path):
        with open(file_path, "w", newline="", encoding="utf-8") as file:
            writer = csv.DictWriter(file, fieldnames=FIELDNAMES)
            writer.writeheader()


def add_expense(file_path: str, expense: Expense) -> None:
    ensure_storage(file_path)
    with open(file_path, "a", newline="", encoding="utf-8") as file:
        writer = csv.DictWriter(file, fieldnames=FIELDNAMES)
        writer.writerow(expense.to_row())


def read_expenses(file_path: str) -> List[Expense]:
    if not os.path.exists(file_path):
        return []
    with open(file_path, "r", newline="", encoding="utf-8") as file:
        reader = csv.DictReader(file)
        if not reader.fieldnames:
            return []
        expenses: List[Expense] = []
        for row in reader:
            if not row:
                continue
            try:
                expenses.append(Expense.from_row(row))
            except (ValueError, KeyError):
                continue
    return expenses
