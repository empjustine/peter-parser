module PeterParser

  # Represents Object whose instances are fully integrated with PeterParser's
  # #_extract! and #extract message calls.
  module Components

    # Value object used to extract nodes from nodesets using XPath or CSS.
    class NodesetSelector

      def initialize(selector=['./'])

        @selector = [*selector]
      end

      def _extract!(resources)

        return resources[:content].search(*@selector)
      end
    end
  end
end


module PeterParser
  module Components
    class NodesetSelector

      def first

        on(:after_extract) { |resources|
          resources.first
        }
      end

      def last

        on(:after_extract) { |resources|
          resources.last
        }
      end

      def content

        on(:after_extract) { |resources|
          [*resources].map(&:content)
        }
      end
    end
  end
end
