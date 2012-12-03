module PeterParser

  # Most of the error subclasses extend StandardError. These are the "normal"
  # exceptions. The other exceptions represent lower-level, more serious, or
  # less recoverable conditions, we won't attempt to handle them.
  class Error < Object::StandardError; end

  # Meaningfull error for a parser without rules to parse
  class NoRulesError < Error; end

  # Meaningfull error for a parser without URLs to parse
  class NoUrlError < Error; end

end
