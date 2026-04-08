import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Scanner;

public class QuizService {
    private static final long QUIZ_TIME_MS = 60_000;

    private final Quiz quiz;
    private final List<Result> attempts;
    private final Scanner scanner;

    public QuizService(Quiz quiz, Scanner scanner) {
        this.quiz = quiz;
        this.scanner = scanner;
        this.attempts = new ArrayList<>();
    }

    public void addQuestion() {
        System.out.println("\n--- Add Question ---");
        int questionId = readInt("Enter question ID: ");
        String questionText = readNonEmptyString("Enter question text: ");

        String[] options = new String[4];
        for (int i = 0; i < 4; i++) {
            options[i] = readNonEmptyString("Enter option " + (i + 1) + ": ");
        }

        int correctAnswer = readIntInRange("Enter correct option (1-4): ", 1, 4);
        String difficulty = readDifficulty();

        Question question = new Question(questionId, questionText, options, correctAnswer, difficulty);
        quiz.addQuestion(question);
        System.out.println("Question added successfully.");
    }

    public void startQuiz(User user) {
        if (!quiz.hasQuestions()) {
            System.out.println("\nNo questions available. Please add questions first.");
            return;
        }

        System.out.println("\n--- Start Quiz ---");
        System.out.println("User: " + user.getName() + " (" + user.getUserId() + ")");

        List<Question> selectedQuestions = selectQuestionsByDifficulty();
        if (selectedQuestions.isEmpty()) {
            System.out.println("No questions found for selected difficulty. Using all questions.");
            selectedQuestions = quiz.getQuestions();
        }

        Collections.shuffle(selectedQuestions);

        long startTime = System.currentTimeMillis();
        int correctCount = 0;
        int wrongCount = 0;
        List<String> wrongDetails = new ArrayList<>();

        for (Question question : selectedQuestions) {
            if (isTimeUp(startTime)) {
                System.out.println("\nTime is up! Auto-submitting the quiz.");
                break;
            }

            displayQuestion(question, startTime);
            int answer = readIntInRange("Your answer (1-4): ", 1, 4);

            if (answer == question.getCorrectAnswer()) {
                correctCount++;
            } else {
                wrongCount++;
                String correctOptionText = question.getOptions()[question.getCorrectAnswer() - 1];
                wrongDetails.add("Q" + question.getQuestionId() + ": Correct option is "
                        + question.getCorrectAnswer() + " - " + correctOptionText);
            }

            if (isTimeUp(startTime)) {
                System.out.println("\nTime is up! Auto-submitting the quiz.");
                break;
            }
        }

        int totalQuestions = correctCount + wrongCount;
        int score = correctCount;
        double percentage = totalQuestions == 0 ? 0.0 : (correctCount * 100.0) / totalQuestions;
        long timeTakenSeconds = (System.currentTimeMillis() - startTime) / 1000;

        Result result = new Result(totalQuestions, correctCount, wrongCount, score,
                percentage, timeTakenSeconds, wrongDetails);
        attempts.add(result);

        showResult(result);
    }

    public void viewLastResult() {
        if (attempts.isEmpty()) {
            System.out.println("\nNo quiz attempts found.");
            return;
        }
        Result last = attempts.get(attempts.size() - 1);
        showResult(last);
    }

    private void showResult(Result result) {
        System.out.println("\n--- Result ---");
        System.out.println("Total Questions: " + result.getTotalQuestions());
        System.out.println("Correct Answers: " + result.getCorrectCount());
        System.out.println("Wrong Answers: " + result.getWrongCount());
        System.out.println("Final Score: " + result.getScore());
        System.out.printf("Percentage: %.2f%%\n", result.getPercentage());
        System.out.println("Time Taken: " + result.getTimeTakenSeconds() + " seconds");

        if (!result.getWrongDetails().isEmpty()) {
            System.out.println("\nCorrect answers for wrong attempts:");
            for (String detail : result.getWrongDetails()) {
                System.out.println("- " + detail);
            }
        }
    }

    private void displayQuestion(Question question, long startTime) {
        long remainingSeconds = getRemainingSeconds(startTime);
        System.out.println("\nTime left: " + remainingSeconds + " seconds");
        System.out.println("Q" + question.getQuestionId() + ": " + question.getQuestionText());
        String[] options = question.getOptions();
        for (int i = 0; i < options.length; i++) {
            System.out.println((i + 1) + ". " + options[i]);
        }
    }

    private List<Question> selectQuestionsByDifficulty() {
        System.out.println("Select difficulty:");
        System.out.println("1. Easy");
        System.out.println("2. Medium");
        System.out.println("3. Hard");
        System.out.println("4. All");

        int choice = readIntInRange("Enter choice (1-4): ", 1, 4);
        if (choice == 4) {
            return quiz.getQuestions();
        }

        String selected;
        if (choice == 1) {
            selected = "easy";
        } else if (choice == 2) {
            selected = "medium";
        } else {
            selected = "hard";
        }

        List<Question> filtered = new ArrayList<>();
        for (Question question : quiz.getQuestions()) {
            if (selected.equalsIgnoreCase(question.getDifficulty())) {
                filtered.add(question);
            }
        }
        return filtered;
    }

    private String readDifficulty() {
        System.out.println("Select difficulty for this question:");
        System.out.println("1. Easy");
        System.out.println("2. Medium");
        System.out.println("3. Hard");
        int choice = readIntInRange("Enter choice (1-3): ", 1, 3);
        if (choice == 1) {
            return "easy";
        } else if (choice == 2) {
            return "medium";
        }
        return "hard";
    }

    private boolean isTimeUp(long startTime) {
        return System.currentTimeMillis() - startTime >= QUIZ_TIME_MS;
    }

    private long getRemainingSeconds(long startTime) {
        long elapsed = System.currentTimeMillis() - startTime;
        long remaining = QUIZ_TIME_MS - elapsed;
        return Math.max(0, remaining / 1000);
    }

    private int readInt(String prompt) {
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

    private int readIntInRange(String prompt, int min, int max) {
        while (true) {
            int value = readInt(prompt);
            if (value >= min && value <= max) {
                return value;
            }
            System.out.println("Please enter a number between " + min + " and " + max + ".");
        }
    }

    private String readNonEmptyString(String prompt) {
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
