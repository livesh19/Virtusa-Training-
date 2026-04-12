import matplotlib.pyplot as plt


def show_category_pie_chart(totals: dict) -> None:
    if not totals:
        print("No data available for chart.")
        return

    labels = list(totals.keys())
    sizes = list(totals.values())

    plt.figure(figsize=(7, 7))
    plt.pie(sizes, labels=labels, autopct="%1.1f%%", startangle=140)
    plt.title("Category-wise Spending")
    plt.axis("equal")
    plt.tight_layout()
    plt.show()
