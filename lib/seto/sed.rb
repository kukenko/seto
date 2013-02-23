require 'seto/editor'

module Seto
  class Sed
    def initialize(enumerator)
      @editor = Seto::Editor.new(enumerator)
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
      result = cover?(pattern, last)
      yield if result && block_given?
      result
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
      @editor.copy
      @editor.load
    end

    alias :n :next

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
      begin
        text = open(filename).read
      rescue
        # ignore
      end
      @editor.append text if text
    end

    alias :r :read

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

    def cover?(pattern, last=nil)
      unless last
        @editor.match? pattern
      else
        @editor.cover? pattern, last
      end
    end
  end
end
