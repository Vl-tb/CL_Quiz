module QuizProtsenkoVakariuk
    class Statistics
      def initialize(writer)
        @correct_answers = 0
        @incorrect_answers = 0
        @writer = writer
      end
  
      def correct_answer
        @correct_answers += 1
      end
  
      def incorrect_answer
        @incorrect_answers += 1
      end
  
      def print_report
        total = @correct_answers + @incorrect_answers
        percent = total.zero? ? 0 : (@correct_answers.to_f / total * 100).round(2)
        report = "Correct: #{@correct_answers}, Incorrect: #{@incorrect_answers}, Success Rate: #{percent}%"
        puts report
        @writer.write(report)
      end
    end
  end
  