module Crodoc
  # Represents a Crystal source file.
  class Source
    # Path to the source file
    getter path : String

    # Contents of the source file
    getter code : String

    @lines : Array(String)?
    @ast : Crystal::ASTNode?
    @fullpath : String?

    # Creates a new source using `code` and `path`.
    #
    # Example:
    #
    # ```crystal
    # path = "./src/source.cr"
    # Crodoc::Source.new(File.read(path), path)
    # ```
    #
    def initialize(@code : String, @path : String)
    end

    # Returns the lines of code by splitting the `code` by on
    # newlines. Lines are cached and lazily loaded.
    #
    # Example:
    #
    # ```crystal
    # source = Crodoc::Source.new("a = 1\nb = 2", "")
    # source.lines # => ["a = 1", "b = 2"]
    # ```
    #
    def lines
      @lines ||= @code.split('\n')
    end

    # Returns AST nodes constructed by `Crystal::Parser`.
    #
    # Example
    #
    # ```crystal
    # source = Crodoc::Source.new(code, path)
    # source.ast
    # ```
    def ast
      @ast ||= Crystal::Parser.new(code).tap do |parser|
        parser.wants_doc = true
        parser.filename = @path
      end.parse
    end

    # The full, expanded path to the source file.
    def fullpath
      @fullpath ||= File.expand_path(@path)
    end

    # Returns true if *filepath* matches the source's path,
    # false if it does not.
    def matches_path?(filepath)
      path == filepath || path == File.expand_path(filepath)
    end
  end
end
