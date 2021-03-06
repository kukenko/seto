require 'spec_helper'
require 'tempfile'

module Seto
  describe Editor do
    SIMPLE = './spec/files/simple.txt'
    SETOIS = './spec/files/seto_is.txt'
    STARTEND = './spec/files/start_end.txt'
    SETO = './spec/files/seto.txt'

    let(:simple) { Editor.new(File.open(SIMPLE).each.with_index(1)) }
    let(:setois) { Editor.new(File.open(SETOIS).each.with_index(1)) }
    let(:startend) { Editor.new(File.open(STARTEND).each.with_index(1)) }
    let(:seto) { Editor.new(File.open(SETO).each.with_index(1)) }

    describe '#address' do
      it 'selects the row by the line number' do
        setois.edit do
          s /is/, 'no' if address(2)
          s /a place name/, 'Hanayome' if address(2)
        end
        .should eql(["Seto is pseudo sed.\n", "Seto no Hanayome.\n"])
      end

      it 'selects the row by the regular expression' do
        setois.edit do
          s /\./, '!' if address(/pseudo/)
        end
        .should eql(["Seto is pseudo sed!\n", "Seto is a place name.\n"])
      end

      it 'selects the row by the line number range' do
        setois.edit do
          s /\./, '!' if address(1, 2)
        end
        .should eql(["Seto is pseudo sed!\n", "Seto is a place name!\n"])
      end

      it 'selects the row by the regexp range' do
        startend.edit do
          s /hello/, 'world' if address(/START/, /END/)
        end
        .should eql(["hello\n", "START world\n", "world\n", "END world\n", "hello\n"])
      end

      it 'selects the row by line number and regexp range' do
        startend.edit do
          s /hello/, 'world' if address(3, /END/)
        end
        .should eql(["hello\n", "START hello\n", "world\n", "END world\n", "hello\n"])
      end

      it 'selects the row by the regexp and line number range' do
        startend.edit do
          s /hello/, 'world' if address(/START/, 3)
        end
        .should eql(["hello\n", "START world\n", "world\n", "END hello\n", "hello\n"])
      end

      context 'with block' do
        it 'selects the row by the line number' do
          setois.edit do
            address(2) {
              s /is/, 'no'
              s /a place name/, 'Hanayome'
            }
          end
          .should eql(["Seto is pseudo sed.\n", "Seto no Hanayome.\n"])
        end

        it 'selects the row by the regular expression' do
          setois.edit do
            address(/place/) {
              s /is/, 'no'
              s /a place name/, 'Hanayome'
            }
          end
          .should eql(["Seto is pseudo sed.\n", "Seto no Hanayome.\n"])
        end

        it 'selects the row by the regexp range' do
          startend.edit do
            address(/START/, /END/) do
              s /hello/, 'world'
            end
          end
          .should eql(["hello\n", "START world\n", "world\n", "END world\n", "hello\n"])
        end

        it 'selects the row by line number and regexp range' do
          startend.edit do
            address(3, /END/) {
              s /hello/, 'world'
            }
          end
          .should eql(["hello\n", "START hello\n", "world\n", "END world\n", "hello\n"])
        end
      end
    end

    describe '#a' do
      it 'appends text to current line' do
        simple.edit { a 'by ruby.'}
        .should eql(["Seto is pseudo sed.\nby ruby."])
      end
    end

    describe '#c' do
      it 'changes the current line with text' do
        simple.edit { c 'This line has been censored.'}
        .should eql(["This line has been censored."])
      end
    end

    describe '#d' do
      it 'deletes current line' do
        simple.edit { d }.should be_empty
      end
    end

    describe '#g' do
      it 'copies the hold space into the pattern space' do
        simple.edit do
          h
          g
        end
        .should eql(["Seto is pseudo sed.\n"])
      end
    end

    # xxx
    describe '#h' do
      it 'copies the pattern space into the hold space' do
        simple.edit { h }
        simple.instance_eval {
          instance_eval { @hold_space }
        }
        .should eql(["Seto is pseudo sed.\n"])
      end
    end

    describe '#i' do
      it 'inserts text before current line' do
        simple.edit { i 'by ruby.' }
        .should eql(["by ruby.Seto is pseudo sed.\n"])
      end
    end

    describe '#lineno' do
      it 'prints current line number to stdout' do
        capture {
          startend.edit {
            lineno if address /START/
          }
        }
        .should eql("2")
      end
    end

    describe '#n' do
      it 'reads the next line' do
        seto.edit {
          address(/^#/) {
            n
            d if address /^$/
          }
        }
        .should eql(["# Seto\n", "Seto is pseudo sed.\n"])
      end
    end

    describe '#p' do
      it 'prints pattern space to stdout' do
        capture {
          simple.edit {
            p
            s /s/, 'S', :g
            p
          }
        }
        .should eql("Seto is pseudo sed.\nSeto iS pSeudo Sed.\n")
      end
    end

    describe '#q' do
      it 'quit the running scripts' do
        simple.edit do
          q
          s /s/, 'S'
        end
        .should eql(["Seto is pseudo sed.\n"])
      end
    end

    describe '#r' do
      it 'read from file' do
        setois.edit { r SIMPLE if address(2) }
        .should eql(["Seto is pseudo sed.\n",
            "Seto is a place name.\nSeto is pseudo sed.\n"])
      end
    end

    describe '#s' do
      it 'changes occurrence of the regular expression into a new value' do
        setois.edit do
          s /is/, 'no'
          s /a place name/, 'Hanayome'
          s /pseudo sed/, 'Hanayome'
        end
        .should eql(["Seto no Hanayome.\n", "Seto no Hanayome.\n"])
      end
      context 'with g flag' do
        it 'changes all occurrence of the regular expression into a new value' do
          simple.edit { s /s/, 'S', :g }
          .should eql(["Seto iS pSeudo Sed.\n"])
        end
      end
    end

    describe '#w' do
      it 'writes to file' do
        tempfile = Tempfile.new('seto_temp')
        setois.edit { w tempfile }
        open(tempfile).read.should eql("Seto is pseudo sed.\nSeto is a place name.\n")
        tempfile.close!
      end
    end

    # xxx
    describe '#x' do
      it 'exchanges the pattern space and hold space' do
        simple.edit do
          h
          x
        end
        .should eql(["Seto is pseudo sed.\n"])
      end
    end

    describe '#y' do
      it 'transforms characters into the other charaters' do
        simple.edit { y 'a-z', 'A-Z' }
        .should eql(["SETO IS PSEUDO SED.\n"])
      end
    end
  end
end
