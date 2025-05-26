require 'yaml'
require 'json'

module QuizProtsenkoVakariuk
  class QuestionData
    attr_accessor :collection

    def initialize
      @collection = []
      @yaml_dir = QuizProtsenkoVakariuk::Quiz.yaml_dir
      @in_ext = QuizProtsenkoVakariuk::Quiz.in_ext
      @threads = []
      load_data
    end

    def to_yaml
      @collection.map(&:to_h).to_yaml
    end

    def save_to_yaml(filename)
      puts filename
      puts prepare_filename(filename)
      File.write(prepare_filename(filename), to_yaml)
    end

    def to_json
      @collection.map(&:to_h).to_json
    end

    def save_to_json(filename)
      File.write(prepare_filename(filename), to_json)
    end

    def prepare_filename(filename)
      File.expand_path(filename, __dir__)
    end

    def each_file
      Dir.glob(File.join(@yaml_dir, "*.#{@in_ext}")) { |f| yield f }
    end

    def in_thread(&block)
      @threads << Thread.new(&block)
    end

    def load_data
      each_file do |file|
        in_thread { load_from(file) }
      end
      @threads.each(&:join)
    end

    def load_from(filename)
      data = YAML.load_file(filename)
      data.each do |item|
        question = item['question']
        answers = item['answers']
        @collection << Question.new(question, answers)
      end
    end
  end
end
