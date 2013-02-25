require 'forwardable'
require 'seto/editor'

module Seto
  class Sed
    extend Forwardable

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

    def_delegator :@editor, :append, :a
    def_delegator :@editor, :change, :c
    def_delegator :@editor, :delete, :d
    def_delegator :@editor, :get, :g
    def_delegator :@editor, :hold, :h
    def_delegator :@editor, :insert, :i
    def_delegator :@editor, :substitute, :s
    def_delegator :@editor, :exchange, :x
    def_delegator :@editor, :transform, :y

    # b
    def branch(label)
      raise NotImplementedError
    end

    # G
    def get!
      raise NotImplementedError
    end

    # H
    def hold!
      raise NotImplementedError
    end

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

    # t
    def test(label)
      raise NotImplementedError
    end

    # w
    def write(filename)
      raise NotImplementedError
    end

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
