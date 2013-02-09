module Seto
  class Sed
    def initialize(enumerator)
      @enumerator = enumerator
      @commands   = []
    end

    def load(&block)
      instance_eval &block
    end

    def run
      @enumerator.map do |line|
        @commands.inject(line) { |result, cmd| cmd.call(result) }
      end
      .select { |line| line }
    end

    def address
      raise NotImplementedError
    end

    def d
      proc = Proc.new do |arg|
        delete arg
      end
      @commands.push proc
    end

    def s(pattern, replacement, flag=nil)
      proc = Proc.new do |arg|
        substitute arg, pattern, replacement, flag
      end
      @commands.push proc
    end

    private

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
      raise NotImplementedError
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
    def delete(arg)
      nil
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
      raise NotImplementedError
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
    def substitute(arg, pattern, replacement, flag)
      arg.sub(pattern, replacement)
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
