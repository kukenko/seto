require 'seto/editor'

module Seto
  class Sed
    def initialize(enumerator)
      @editor = Seto::Editor.new(enumerator)
      @result = []
      @range_table = {}
    end

    def edit(&block)
      loop do
        @editor.load
        instance_eval &block
        @editor.copy
      end
      @editor.result.reject { |l| l.empty? }
    end

    def address(pattern, last=nil)
      condition = within_the_limit?(pattern, last)
      yield if condition && block_given?
      condition
    end

    # :label
    def label
      raise NotImplementedError
    end

    # =
    def lineno
      raise NotImplementedError
    end

    # a
    def append(text)
      @editor.append text
    end

    alias :a :append

    # b
    def branch(label)
      raise NotImplementedError
    end

    # c
    def change(text)
      @editor.change text
    end

    alias :c :change

    # d
    def delete
      @editor.delete
    end

    alias :d :delete

    # g
    def get
      raise NotImplementedError
    end

    # G
    def get!
      raise NotImplementedError
    end

    # h
    def hold
      raise NotImplementedError
    end

    # H
    def hold!
      raise NotImplementedError
    end

    # i
    def insert(text)
      @editor.insert text
    end

    alias :i :insert

    # l
    def look
      raise NotImplementedError
    end

    # n
    def next
      raise NotImplementedError
    end

    # N
    def next!
      raise NotImplementedError
    end

    # p
    def print
      Kernel.print @editor.current_line
    end

    alias :p :print

    # P
    def print!
      raise NotImplementedError
    end

    # q
    def quit
      @editor.copy
      raise StopIteration
    end

    alias :q :quit

    # r
    def read(filename)
      raise NotImplementedError
    end

    # s
    def substitute(pattern, replace, flag=nil)
      @editor.substitute pattern, replace, flag
    end

    alias :s :substitute

    # t
    def test(label)
      raise NotImplementedError
    end

    # w
    def write(filename)
      raise NotImplementedError
    end

    # x
    def exchange
      raise NotImplementedError
    end

    # y
    def transform(pattern, replace)
      @editor.transform pattern, replace
    end

    alias :y :transform

    private

    # xxx
    def within_the_limit?(pattern, last=nil)
      unless last
        case pattern
        when Fixnum then pattern == @editor.line_number
        when Regexp then pattern =~ @editor.current_line
        else
          pattern
        end
      else
        combination = [pattern.class, last.class]
        case combination
        when [Fixnum, Fixnum] then (pattern..last).cover? @editor.line_number
        when [Regexp, Regexp]
          unless @range_table.key? pattern
            if pattern =~ @editor.current_line
              @range_table[pattern] = @editor.line_number
              true
            else
              false
            end
          else
            unless @range_table.key? last
              if last =~ @editor.current_line
                @range_table[last] = @editor.line_number
              end
              true
            else
              false
            end
          end
        when [Fixnum, Regexp] then false
        when [Rangep, Fixnum] then false
        end
      end
    end
  end
end
