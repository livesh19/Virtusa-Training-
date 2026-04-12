RATES_PER_KM = {
    "Economy": 10,
    "Premium": 18,
    "SUV": 25,
}

SURGE_START_HOUR = 17
SURGE_END_HOUR = 20
SURGE_MULTIPLIER = 1.5


def is_surge_hour(hour: int) -> bool:
    return SURGE_START_HOUR <= hour <= SURGE_END_HOUR


def calculate_fare(distance: float, vehicle_type: str, hour: int) -> tuple[float, float, bool]:
    if distance <= 0:
        raise ValueError("Distance must be greater than 0.")
    if hour < 0 or hour > 23:
        raise ValueError("Hour must be between 0 and 23.")
    if vehicle_type not in RATES_PER_KM:
        raise KeyError("Service Not Available")

    rate = RATES_PER_KM[vehicle_type]
    base_fare = distance * rate

    surge_applied = is_surge_hour(hour)
    final_fare = base_fare * (SURGE_MULTIPLIER if surge_applied else 1.0)

    return rate, base_fare, surge_applied, final_fare


def print_receipt(vehicle_type: str, distance: float, rate: float, base_fare: float,
                  surge_applied: bool, final_fare: float) -> None:
    print("------ Ride Receipt ------")
    print(f"Vehicle Type : {vehicle_type}")
    print(f"Distance     : {distance:.2f} km")
    print(f"Rate/km      : 2{rate:.0f}")
    print(f"Base Fare    : 2{base_fare:.2f}")
    if surge_applied:
        print(f"Surge        : Applied ({SURGE_MULTIPLIER}x)")
    else:
        print("Surge        : Not Applied")
    print(f"Final Fare   : 2{final_fare:.2f}")
    print("-------------------")


def prompt_distance() -> float:
    value = input("Enter distance (km): ").strip()
    return float(value)


def prompt_vehicle() -> str:
    value = input("Enter vehicle type (Economy, Premium, SUV): ").strip()
    return value


def prompt_hour() -> int:
    value = input("Enter hour (0-23): ").strip()
    return int(value)


def run_once() -> None:
    try:
        distance = prompt_distance()
        vehicle_type = prompt_vehicle()
        hour = prompt_hour()

        rate, base_fare, surge_applied, final_fare = calculate_fare(
            distance=distance,
            vehicle_type=vehicle_type,
            hour=hour,
        )
        print_receipt(vehicle_type, distance, rate, base_fare, surge_applied, final_fare)
    except ValueError as exc:
        print(f"Input error: {exc}")
    except KeyError:
        print("Service Not Available")


def main() -> None:
    while True:
        run_once()
        again = input("Calculate another fare? (y/n): ").strip().lower()
        if again != "y":
            break


if __name__ == "__main__":
    main()
