require "./crodoc/*"

# TODO: Write documentation
module Crodoc

end

source = Crodoc::Source.new(File.read("./src/cli.cr"), "./src/cli.cr")
lexer = Crodoc::Tokenizer.new(source)

lexer.run do |token|
  # case token.type
  # when :COMMENT
    pp token
  # end
end
