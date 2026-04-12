import os
from datetime import datetime

from analytics import category_totals, highest_category, monthly_summary
from expense import CATEGORY_OPTIONS, Expense
from storage import add_expense, read_expenses
from visualization import show_category_pie_chart

DATA_FILE = os.path.join(os.path.dirname(__file__), "data", "expenses.csv")


def print_expenses(expenses: list[Expense]) -> None:
    if not expenses:
        print("No expenses recorded yet.")
        return

    header = f"{'Date':<12} {'Category':<14} {'Amount':>10}  Description"
    print(header)
    print("-" * len(header))
    for exp in expenses:
        print(f"{exp.date:<12} {exp.category:<14} {exp.amount:>10.2f}  {exp.description}")


def add_expense_flow() -> None:
    try:
        date_str = input("Enter date (YYYY-MM-DD): ").strip()
        date_str = Expense.parse_date(date_str)

        print(f"Allowed categories: {', '.join(CATEGORY_OPTIONS)}")
        category = input("Enter category: ").strip()
        category = Expense.validate_category(category, CATEGORY_OPTIONS)

        amount_str = input("Enter amount: ").strip()
        amount = Expense.parse_amount(amount_str)

        description = input("Enter description: ").strip()

        expense = Expense(date=date_str, category=category, amount=amount, description=description)
        add_expense(DATA_FILE, expense)
        print("Expense added successfully!")
    except ValueError as exc:
        print(f"Input error: {exc}")


def view_expenses_flow() -> None:
    expenses = read_expenses(DATA_FILE)
    print_expenses(expenses)


def monthly_summary_flow() -> None:
    try:
        month_input = input("Enter month (YYYY-MM): ").strip()
        month_date = datetime.strptime(month_input, "%Y-%m")
    except ValueError:
        print("Invalid month format. Use YYYY-MM.")
        return

    expenses = read_expenses(DATA_FILE)
    total, count = monthly_summary(expenses, month_date.year, month_date.month)
    print(f"Total spending for {month_input}: {total:.2f}")
    print(f"Number of transactions: {count}")


def category_analysis_flow() -> None:
    expenses = read_expenses(DATA_FILE)
    totals = category_totals(expenses)

    if not totals:
        print("No expenses recorded yet.")
        return

    print("Category-wise Spending:")
    for category, total in sorted(totals.items()):
        print(f"{category}: {total:.2f}")

    top_category, top_amount = highest_category(totals)
    if top_category:
        print(f"Highest spending category: {top_category} ({top_amount:.2f})")


def pie_chart_flow() -> None:
    expenses = read_expenses(DATA_FILE)
    totals = category_totals(expenses)
    show_category_pie_chart(totals)


def main() -> None:
    while True:
        print("\nSmart Expense Tracker")
        print("1. Add Expense")
        print("2. View Expenses")
        print("3. Monthly Summary")
        print("4. Category Analysis")
        print("5. Show Pie Chart")
        print("6. Exit")

        choice = input("Enter choice: ").strip()

        if choice == "1":
            add_expense_flow()
        elif choice == "2":
            view_expenses_flow()
        elif choice == "3":
            monthly_summary_flow()
        elif choice == "4":
            category_analysis_flow()
        elif choice == "5":
            pie_chart_flow()
        elif choice == "6":
            print("Goodbye!")
            break
        else:
            print("Invalid choice. Please enter 1-6.")


if __name__ == "__main__":
    main()
