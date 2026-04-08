package Passwordvalidator;
import java.util.Scanner;

public class PasswordValidator {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        while (true) {
            System.out.print("Enter your password: ");
            String password = scanner.nextLine();

            if (isPasswordValid(password)) {
                System.out.println("Password accepted successfully!");
                break;
            }

            printFeedback(password);
        }

        scanner.close();
    }

    public static boolean isPasswordValid(String password) {
        return isLengthValid(password) && hasUpperCase(password) && hasDigit(password);
    }

    public static boolean isLengthValid(String password) {
        return password != null && password.length() >= 8;
    }

    public static boolean hasUpperCase(String password) {
        if (password == null) {
            return false;
        }

        for (int i = 0; i < password.length(); i++) {
            if (Character.isUpperCase(password.charAt(i))) {
                return true;
            }
        }
        return false;
    }

    public static boolean hasDigit(String password) {
        if (password == null) {
            return false;
        }

        for (int i = 0; i < password.length(); i++) {
            if (Character.isDigit(password.charAt(i))) {
                return true;
            }
        }
        return false;
    }

    public static void printFeedback(String password) {
        if (!isLengthValid(password)) {
            System.out.println("Password must be at least 8 characters long");
        }
        if (!hasUpperCase(password)) {
            System.out.println("Password is missing an uppercase letter");
        }
        if (!hasDigit(password)) {
            System.out.println("Password is missing a digit");
        }
    }
}
