module Seto
  class Editor
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

    def change(text)
      @current_line = text
    end

    def delete
      @current_line = ''
    end

    def insert(text)
      @current_line = "#{text}#{@current_line}"
    end

    def substitute(pattern, replace, flag)
      method = :sub!
      method = :gsub! if flag && flag == :g
      @current_line.send(method, pattern, replace)
    end

    def transform(pattern, replace)
      @current_line.tr! pattern, replace
    end

    def dup
      @current_line.dup
    end
  end
end
