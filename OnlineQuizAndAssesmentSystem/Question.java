import java.util.Arrays;

public class Question {
    private int questionId;
    private String questionText;
    private String[] options;
    private int correctAnswer; // 1-4
    private String difficulty; // easy/medium/hard

    public Question(int questionId, String questionText, String[] options, int correctAnswer, String difficulty) {
        this.questionId = questionId;
        this.questionText = questionText;
        this.options = new String[4];
        if (options != null && options.length == 4) {
            System.arraycopy(options, 0, this.options, 0, 4);
        }
        this.correctAnswer = correctAnswer;
        this.difficulty = difficulty;
    }

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public String getQuestionText() {
        return questionText;
    }

    public void setQuestionText(String questionText) {
        this.questionText = questionText;
    }

    public String[] getOptions() {
        return Arrays.copyOf(options, options.length);
    }

    public void setOptions(String[] options) {
        if (options != null && options.length == 4) {
            System.arraycopy(options, 0, this.options, 0, 4);
        }
    }

    public int getCorrectAnswer() {
        return correctAnswer;
    }

    public void setCorrectAnswer(int correctAnswer) {
        this.correctAnswer = correctAnswer;
    }

    public String getDifficulty() {
        return difficulty;
    }

    public void setDifficulty(String difficulty) {
        this.difficulty = difficulty;
    }
}
