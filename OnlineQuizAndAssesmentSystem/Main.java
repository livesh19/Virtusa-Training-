import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        Quiz quiz = new Quiz();
        QuizService quizService = new QuizService(quiz, scanner);

        System.out.println("Welcome to the Online Quiz & Assessment System");
        String name = readNonEmptyString(scanner, "Enter your name: ");
        String userId = readNonEmptyString(scanner, "Enter your user ID: ");
        User user = new User(userId, name);

        boolean running = true;
        while (running) {
            System.out.println("\n--- Main Menu ---");
            System.out.println("1. Add Question (Admin)");
            System.out.println("2. Start Quiz");
            System.out.println("3. View Last Result");
            System.out.println("4. Exit");

            int choice = readIntInRange(scanner, "Enter choice (1-4): ", 1, 4);
            switch (choice) {
                case 1:
                    quizService.addQuestion();
                    break;
                case 2:
                    quizService.startQuiz(user);
                    break;
                case 3:
                    quizService.viewLastResult();
                    break;
                case 4:
                    running = false;
                    System.out.println("Goodbye!");
                    break;
                default:
                    System.out.println("Invalid choice.");
            }
        }

        scanner.close();
    }

    private static int readIntInRange(Scanner scanner, String prompt, int min, int max) {
        while (true) {
            int value = readInt(scanner, prompt);
            if (value >= min && value <= max) {
                return value;
            }
            System.out.println("Please enter a number between " + min + " and " + max + ".");
        }
    }

    private static int readInt(Scanner scanner, String prompt) {
        while (true) {
            System.out.print(prompt);
            String input = scanner.nextLine().trim();
            try {
                return Integer.parseInt(input);
            } catch (NumberFormatException ex) {
                System.out.println("Please enter a valid number.");
            }
        }
    }

    private static String readNonEmptyString(Scanner scanner, String prompt) {
        while (true) {
            System.out.print(prompt);
            String input = scanner.nextLine().trim();
            if (!input.isEmpty()) {
                return input;
            }
            System.out.println("Input cannot be empty.");
        }
    }
}
