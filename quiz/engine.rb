module QuizProtsenkoVakariuk
    class Engine
      def initialize
        QuizProtsenkoVakariuk::Quiz.config do |q|
          q.yaml_dir = "quiz/yml/"
          q.in_ext = "yaml"
          q.answers_dir = "quiz/answers/"
        end
        @question_collection = QuestionData.new
        @question_collection.save_to_yaml('questions_out.yaml')
        @question_collection.save_to_json('questions_out.json')
  
        @input_reader = InputReader.new
        @user_name = @input_reader.read(welcome_message: "Enter your name:")
        @current_time = Time.now.strftime("%Y%m%d_%H%M%S")
        @writer = FileWriter.new("w", "#{@user_name}_#{@current_time}")
        @statistics = Statistics.new(@writer)
      end
  
      def run
        @question_collection.collection.each do |question|
          puts "\n#{question}"
          question.display_answers.each { |ans| puts ans }
          user_answer = get_answer_by_char(question)
          correct = question.question_correct_answer
          check(user_answer, correct)
        end
        @statistics.print_report
      end
  
      def check(user_answer, correct_answer)
        if user_answer == correct_answer
          @writer.write("Correct: #{user_answer}")
          @statistics.correct_answer
        else
          @writer.write("Incorrect: #{user_answer} (Correct: #{correct_answer})")
          @statistics.incorrect_answer
        end
      end
  
      def get_answer_by_char(question)
        @input_reader.read(
          welcome_message: "Your answer:",
          validator: ->(input) { !input.empty? },
          process: ->(input) { question.find_answer_by_char(input[0]) },
          error_message: "Please enter a valid answer character"
        )
      end
    end
  end
  