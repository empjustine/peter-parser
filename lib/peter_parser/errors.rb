module PeterParser

  class Error < Object::StandardError; end

  class NoRulesError < Error; end
  class NoMethodError < Error; end
end
