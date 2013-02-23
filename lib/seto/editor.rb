module Seto
  class Editor
    attr_reader :current_line, :line_number, :result
    def initialize(enumerator)
      @enumerator = enumerator
      @patterns = {}
      @result = []
    end

    def load
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
      @current_line.send method, pattern, replace
    end

    def transform(pattern, replace)
      @current_line.tr! pattern, replace
    end

    def copy
      @result << @current_line.dup
    end

    def match?(condition)
      case condition
      when Fixnum then condition == @line_number
      when Regexp then condition =~ @current_line
      else
        condition
      end
    end

    def cover?(first, last)
      case [first.class, last.class]
      when [Fixnum, Fixnum] then cover1 first, last
      else cover2 first, last
      end
    end

    private

    def cover1(first, last)
      (first..last).cover? @line_number
    end

    def cover2(first, last)
      (match_first? first) && (match_second? last)
    end

    def match_first?(condition)
      case condition
      when Fixnum then condition <= @line_number
      when Regexp
        unless @patterns.has_key? condition
          if match? condition
            @patterns[condition] = @line_number
            true
          else
            false
          end
        else
          true
        end
      end
    end

    def match_second?(condition)
      case condition
      when Fixnum then condition >= @line_number
      when Regexp
        unless @patterns.has_key? condition
          if match? condition
            @patterns[condition] = @line_number
          end
          true
        else
          false
        end
      end
    end
  end
end
