import java.util.ArrayList;
import java.util.List;

public class Result {
    private int totalQuestions;
    private int correctCount;
    private int wrongCount;
    private int score;
    private double percentage;
    private long timeTakenSeconds;
    private List<String> wrongDetails;

    public Result(int totalQuestions, int correctCount, int wrongCount, int score,
                  double percentage, long timeTakenSeconds, List<String> wrongDetails) {
        this.totalQuestions = totalQuestions;
        this.correctCount = correctCount;
        this.wrongCount = wrongCount;
        this.score = score;
        this.percentage = percentage;
        this.timeTakenSeconds = timeTakenSeconds;
        this.wrongDetails = wrongDetails == null ? new ArrayList<>() : new ArrayList<>(wrongDetails);
    }

    public int getTotalQuestions() {
        return totalQuestions;
    }

    public void setTotalQuestions(int totalQuestions) {
        this.totalQuestions = totalQuestions;
    }

    public int getCorrectCount() {
        return correctCount;
    }

    public void setCorrectCount(int correctCount) {
        this.correctCount = correctCount;
    }

    public int getWrongCount() {
        return wrongCount;
    }

    public void setWrongCount(int wrongCount) {
        this.wrongCount = wrongCount;
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
    }

    public double getPercentage() {
        return percentage;
    }

    public void setPercentage(double percentage) {
        this.percentage = percentage;
    }

    public long getTimeTakenSeconds() {
        return timeTakenSeconds;
    }

    public void setTimeTakenSeconds(long timeTakenSeconds) {
        this.timeTakenSeconds = timeTakenSeconds;
    }

    public List<String> getWrongDetails() {
        return new ArrayList<>(wrongDetails);
    }

    public void setWrongDetails(List<String> wrongDetails) {
        this.wrongDetails = wrongDetails == null ? new ArrayList<>() : new ArrayList<>(wrongDetails);
    }
}
