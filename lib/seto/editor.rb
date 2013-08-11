module Seto
  class Editor
    attr_reader :current_line, :line_number, :result
    def initialize(enumerator)
      @enumerator = enumerator
      @patterns = {}
      @result = []
      @hold_space = []
    end

    def edit(&block)
      loop do
        load_line
        instance_eval &block
        copy_to_result
      end
      result.reject { |l| l.empty? }
    end

    def address(pattern, last=nil)
      result = unless last
                 match? pattern
               else
                 cover? pattern, last
               end
      yield if result && block_given?
      result
    end

    def load_line
      @current_line, @line_number = @enumerator.next
    end

    def append(text)
      @current_line += text
    end
    alias_method :a, :append

    def change(text)
      @current_line = text
    end
    alias_method :c, :change

    def delete
      @current_line = ''
    end
    alias_method :d, :delete

    def insert(text)
      @current_line = "#{text}#{@current_line}"
    end
    alias_method :i, :insert

    def substitute(pattern, replace, flag=nil)
      method = :sub!
      method = :gsub! if flag && flag == :g
      @current_line.send method, pattern, replace
    end
    alias_method :s, :substitute

    def transform(pattern, replace)
      @current_line.tr! pattern, replace
    end
    alias_method :y, :transform

    def copy_to_result
      @result << @current_line.dup
    end

    def get
      @current_line = @hold_space.pop
    end
    alias_method :g, :get

    def hold
      @hold_space << @current_line.dup
    end
    alias_method :h, :hold

    def exchange
      @current_line, hs = @hold_space.pop, @current_line
      @hold_space << hs
    end
    alias_method :x, :exchange

    def lineno
      Kernel.print @line_number
    end

    def next
      copy_to_result
      load_line
    end
    alias_method :n, :next

    def print
      Kernel.print @current_line
    end
    alias_method :p, :print

    def quit
      copy_to_result
      raise StopIteration
    end
    alias_method :q, :quit

    def read(filename)
      begin
        text = open(filename).read
      rescue
        # ignore
      end
      append text if text
    end
    alias_method :r, :read

    def write(filename)
      open(filename, 'a') do |f|
        f.write @current_line
      end
    end
    alias_method :w, :write

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
      when [Fixnum, Fixnum] then within first, last
      else cover2 first, last
      end
    end

    private

    def within(first, last)
      (first..last).cover? @line_number
    end

    def cover2(first, last)
      (match_first? first) && (match_second? first, last)
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

    def match_second?(*conditions)
      condition = conditions[1]
      case condition
      when Fixnum then condition >= @line_number
      when Regexp
        unless @patterns.has_key? condition
          if match? condition
            @patterns[condition] = @line_number
          end
          true
        else
          conditions.each { |key| @patterns.delete key }
          false
        end
      end
    end
  end
end
