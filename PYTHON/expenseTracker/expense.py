from dataclasses import dataclass
from datetime import datetime
from typing import List

CATEGORY_OPTIONS = [
    "Food",
    "Travel",
    "Bills",
    "Shopping",
    "Health",
    "Education",
    "Entertainment",
    "Other",
]


@dataclass
class Expense:
    date: str
    category: str
    amount: float
    description: str

    @staticmethod
    def parse_date(date_str: str) -> str:
        datetime.strptime(date_str, "%Y-%m-%d")
        return date_str

    @staticmethod
    def parse_amount(amount_str: str) -> float:
        amount = float(amount_str)
        if amount < 0:
            raise ValueError("Amount must be non-negative.")
        return amount

    @staticmethod
    def validate_category(category: str, allowed: List[str]) -> str:
        if category not in allowed:
            raise ValueError(f"Category must be one of: {', '.join(allowed)}")
        return category

    @classmethod
    def from_row(cls, row: dict) -> "Expense":
        return cls(
            date=row.get("date", ""),
            category=row.get("category", ""),
            amount=float(row.get("amount", 0.0)),
            description=row.get("description", ""),
        )

    def to_row(self) -> dict:
        return {
            "date": self.date,
            "category": self.category,
            "amount": f"{self.amount:.2f}",
            "description": self.description,
        }
