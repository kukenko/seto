module Seto
  class PatternSpace
    attr_reader :line_number
    def initialize(enumerator)
      @enumerator = enumerator
    end

    def update
      @current_line, @line_number = @enumerator.next
    end

    def append(text)
      @current_line += text
    end

    def delete
      @current_line = ''
    end

    def insert(text)
      @current_line = "#{text}#{@current_line}"
    end

    def sub(patern, replace)
      @current_line.sub!(patern, replace)
    end

    def dup
      @current_line.dup
    end
  end
end
