require 'seto/pattern_space'

module Seto
  class Sed
    def initialize(enumerator)
      @enumerator = enumerator
      @commands = []
      @pattern_space = Seto::PatternSpace.new
      @result = []
    end

    def edit(&block)
      instance_eval &block
      run
    end

    def address(first, second=nil)
      condition = limit? first, second
      if condition && block_given?
        yield
        run
      end
      condition
    end

    def a(text)
      proc = Proc.new { append text }
      @commands.push proc
    end

    def d
      proc = Proc.new { delete }
      @commands.push proc
    end

    def i(text)
      proc = Proc.new { insert text }
      @commands.push proc
    end

    def s(pattern, replacement, flag=nil)
      proc = Proc.new { substitute pattern, replacement, flag }
      @commands.push proc
    end

    private

    def run
      loop do
        @pattern_space.update @enumerator.next
        @commands.inject(@pattern_space) { |result, cmd| cmd.call }
        @result << @pattern_space.dup
      end
      @result.reject { |l| l.empty? }
    end

    def limit?(first, second=nil)
      first == 1
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
    def substitute(pattern, replacement, flag)
      @pattern_space.sub(pattern, replacement)
    end

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
  end
end
