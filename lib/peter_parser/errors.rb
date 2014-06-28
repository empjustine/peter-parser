module PeterParser

  # Most of the error subclasses extend StandardError. These are the "normal"
  # exceptions. The other exceptions represent lower-level, more serious, or
  # less recoverable conditions, we won't attempt to handle them.
  class Error < Object::StandardError; end

  # Meaningfull error for a parser lacking manifest(s)
  class NoManifestError < Error; end

  # Meaningfull error for a parser without URL(s) to parse
  class NoUrlError < Error; end

end
