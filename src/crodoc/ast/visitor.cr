module Crodoc::AST
  # Visitor to help traverse the Crystal AST
  class Visitor < Crystal::Visitor
    # The source to traverse
    getter source : Source

    # Creates an instance of this visitor.
    #
    # Example:
    #
    # ```crystal
    # visitor = Crodoc::AST::Visitor.new(source)
    # ```
    def initialize(@source)
      @source.ast.accept(self)
    end

    def visit_any(node)
      puts node.type
    end

    def code
      @source.code
    end
  end
end
