require 'seto/pattern_space'

module Seto
  class Sed
    def initialize(enumerator)
      @pattern_space = Seto::PatternSpace.new(enumerator)
      @result = []
    end

    def edit(&block)
      loop do
        @pattern_space.update
        instance_eval &block
        @result << @pattern_space.dup
      end
      @result.reject { |l| l.empty? }
    end

    def address(first, second=nil)
      condition = limit? first, second
      if condition && block_given?
        yield
      end
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

    # a \
    def append(text)
      @pattern_space.append text
    end

    alias :a :append

    # b label
    def branch(label)
      raise NotImplementedError
    end

    # c \
    def change(text)
      raise NotImplementedError
    end

    # d
    def delete
      @pattern_space.delete
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

    # i \
    def insert(text)
      @pattern_space.insert text
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

    # r filename
    def read(filename)
      raise NotImplementedError
    end

    # s/.../.../flg
    def substitute(pattern, replacement, flag=nil)
      @pattern_space.sub(pattern, replacement)
    end

    alias :s :substitute

    # t label
    def test(label)
      raise NotImplementedError
    end

    # w filename
    def write(filename)
      raise NotImplementedError
    end

    # x
    def exchange
      raise NotImplementedError
    end

    # y/.../.../
    def transform
      raise NotImplementedError
    end

    private

    # xxx
    def limit?(first, second=nil)
      first == 1
    end
  end
end
