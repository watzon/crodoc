require "compiler/crystal/syntax/**"

module Crodoc
  # Represents a Crystal syntaxt tokenizer based on `Crystal::Lexer`.
  #
  # Example:
  #
  # ```crystal
  # source = Crodoc::Source.new(code, path)
  # tokenizer = Crodoc::Tokenizer.new(source)
  # tokenizer.run do |token|
  #   puts token
  # end
  # ```
  #
  class Tokenizer
    @lexer : Crystal::Lexer

    # Instantiates a `Tokenizer` using `source`.
    #
    # Example:
    #
    # ```crystal
    # source = Crodoc::Source.new(code, path)
    # Crodoc::Tokenizer.new(source)
    # ```
    #
    def initialize(source : Source)
      @lexer = Crystal::Lexer.new(source.code).tap do |lexer|
        lexer.count_whitespace = true
        lexer.comments_enabled = true
        lexer.wants_raw = true
        lexer.filename = source.path
      end
    end

    # Instantiates a `Tokenizer` using a `Crystal::Lexer`.
    #
    # Example:
    #
    # ```crystal
    # lexer = Crystal::Lexer.new(code)
    # Crodoc::Tokenizer.new(lexer)
    # ```
    #
    def initialize(@lexer : Crystal::Lexer)
    end

    # Runs the tokenizer and yields each token as a block argument.
    #
    # Example:
    #
    # ```crystal
    # Crodoc::Tokenizer.new(source).run do |token|
    #   puts token
    # end
    # ```
    def run(&block : Crystal::Token ->)
      run_normal_state(@lexer, &block)
      true
    rescue e : Crystal::SyntaxException
      false
    end

    private def run_normal_state(
      lexer,
      break_on_rcurly = false,
      &block : Crystal::Token ->
    )
      loop do
        token = @lexer.next_token
        yield token

        case token.type
        when :DELIMITER_START
          run_delimiter_state lexer, token, &block
        when :STRING_ARRAY_START, :SYMBOL_ARRAY_START
          run_array_state lexer, token, &block
        when :EOF
          break
        when :"}"
          break if break_on_rcurly
        end
      end
    end

    private def run_delimiter_state(lexer, token, &block : Crystal::Token ->)
      loop do
        token = @lexer.next_string_token(token.delimiter_state)
        yield token

        case token.type
        when :DELIMITER_END
          break
        when :INTERPOLATION_START
          run_normal_state lexer, break_on_rcurly: true, &block
        when :EOF
          break
        end
      end
    end

    private def run_array_state(lexer, token, &block : Crystal::Token ->)
      loop do
        lexer.next_string_array_token
        yield token

        case token.type
        when :STRING_ARRAY_END, :EOF
          break
        end
      end
    end
  end
end
