module Seto
  class PatternSpace
    def update(line)
      @pattern_space = line[0]
      @current_line  = line[1]
    end

    def append(text)
      @pattern_space += text
    end

    def delete
      @pattern_space = ''
    end

    def insert(text)
      @pattern_space = "#{text}#{@pattern_space}"
    end

    def sub(patern, replace)
      @pattern_space.sub!(patern, replace)
    end

    def dup
      @pattern_space.dup
    end
  end
end
