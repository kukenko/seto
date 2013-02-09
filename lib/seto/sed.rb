module Seto
  class Sed
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
    def delete
      raise NotImplementedError
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

    # s/.../.../
    def substitute
      raise NotImplementedError
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
