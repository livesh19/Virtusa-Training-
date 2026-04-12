import java.util.ArrayList;
import java.util.List;

public class Quiz {
    private final List<Question> questions;

    public Quiz() {
        this.questions = new ArrayList<>();
    }

    public void addQuestion(Question question) {
        if (question != null) {
            questions.add(question);
        }
    }

    public List<Question> getQuestions() {
        return new ArrayList<>(questions);
    }

    public boolean hasQuestions() {
        return !questions.isEmpty();
    }
}
