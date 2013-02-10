module Seto
  class Sed
    def initialize(enumerator)
      @enumerator = enumerator
      @commands = []
      @pattern_space = []
    end

    def edit(&block)
      instance_eval &block
      run
    end

    def address
      raise NotImplementedError
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
      @enumerator.map do |line|
        @pattern_space.push line
        @commands.inject(line) { |result, cmd| cmd.call }
        result = @pattern_space.dup
        @pattern_space.clear
        result.join
      end
      .reject { |line| line.empty? }
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
      @pattern_space.each { |line| line << text }
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
      @pattern_space.clear
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
      @pattern_space.map! { |line| text << line }
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
      @pattern_space.each { |line| line.sub!(pattern, replacement) }
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
