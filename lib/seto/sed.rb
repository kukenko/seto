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

    def_delegator :@editor, :append, :a
    def_delegator :@editor, :change, :c
    def_delegator :@editor, :delete, :d
    def_delegator :@editor, :get, :g
    def_delegator :@editor, :hold, :h
    def_delegator :@editor, :insert, :i
    def_delegator :@editor, :lineno
    def_delegator :@editor, :next, :n
    def_delegator :@editor, :print, :p
    def_delegator :@editor, :quit, :q
    def_delegator :@editor, :read, :r
    def_delegator :@editor, :substitute, :s
    def_delegator :@editor, :exchange, :x
    def_delegator :@editor, :transform, :y

    # :label
    def label
      raise NotImplementedError
    end

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

    # N
    def next!
      raise NotImplementedError
    end

    # P
    def print!
      raise NotImplementedError
    end

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
