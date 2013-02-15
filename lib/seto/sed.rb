require 'seto/editor'

module Seto
  class Sed
    def initialize(enumerator)
      @editor = Seto::Editor.new(enumerator)
      @result = []
    end

    def edit(&block)
      loop do
        @editor.update
        instance_eval &block
        @result << @editor.dup
      end
      @result.reject { |l| l.empty? }
    end

    def address(pattern, last=nil)
      condition = limit?(pattern, last)
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
      raise NotImplementedError
    end

    # P
    def print!
      raise NotImplementedError
    end

    # q
    def quite
      raise NotImplementedError
    end

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
    def limit?(pattern, last=nil)
      pattern == @editor.line_number
    end
  end
end
