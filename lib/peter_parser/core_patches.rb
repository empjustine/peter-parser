require 'peter_parser/core_patches/callbacks'

module PeterParser

  module CorePatches

    module ObjectExtract

      # fallback for resource extraction
      def _extract!(resources=nil)

        return self
      end

      # standard way to extract resources
      # triggers all extract callbacks
      def extract(resources=nil)

        resources = trigger_pipeline([:before_extract, :b], resources)
        resources = _extract!(resources)
        resources = trigger_pipeline([:a, :after_extract], resources)

        return resources
      end
    end

    module ListExtract

      # resolves extract by delegating to child nodes
      def _extract!(resources)

        return map{ |rule|
          rule.extract(resources)
        }
      end
    end

    module HashExtract

      # resolves extract by delegating to child nodes
      def _extract!(resources)

        return ::Hash[map{ |field, rule|
          [field, rule.extract(resources)]
        }]
      end
    end
  end
end

#single point of insertion for CorePatches::ObjectExtract
class Object

  include PeterParser::CorePatches::ObjectExtract
end

#single point of insertion for CorePatches::ListExtract
class Array

  include PeterParser::CorePatches::ListExtract
end

#single point of insertion for CorePatches::ListExtract
class Set

  include PeterParser::CorePatches::ListExtract
end

#single point of insertion for CorePatches::HashExtract
class Hash

  include PeterParser::CorePatches::HashExtract
end
