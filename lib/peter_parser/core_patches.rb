require 'peter_parser/core_patches/callbacks'

module PeterParser

  # This module keeps most monkey patches done by us under control.
  module CorePatches

    module ObjectExtract

      # Fallback for resource extraction
      def _extract!(resources=nil)

        return self
      end

      # Standard way to extract resources
      #
      # Triggers all extract callbacks
      def extract(resources=nil)

        resources = trigger_pipeline([:before_extract, :b], resources)
        resources = _extract!(resources)
        resources = trigger_pipeline([:a, :after_extract], resources)

        return resources
      end
    end

    module ListExtract

      # Resolves extract by delegating to child nodes
      def _extract!(resources)

        return map { |rule|
          rule.extract(resources)
        }
      end
    end

    module HashExtract

      # Resolves extract by delegating to child nodes
      def _extract!(resources)

        return ::Hash[map { |field, rule|
          [field, rule.extract(resources)]
        }]
      end
    end
  end
end

# Single point of insertion for CorePatches::ObjectExtract
class Object

  include PeterParser::CorePatches::ObjectExtract
end

# Single point of insertion for CorePatches::ListExtract
class Array

  include PeterParser::CorePatches::ListExtract
end

# Single point of insertion for CorePatches::ListExtract
class Set

  include PeterParser::CorePatches::ListExtract
end

# Single point of insertion for CorePatches::HashExtract
class Hash

  include PeterParser::CorePatches::HashExtract
end
