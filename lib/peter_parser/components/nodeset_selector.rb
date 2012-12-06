module PeterParser

  module Components

    #Value object used to extract nodes from nodesets using XPath or CSS.
    class NodesetSelector

      def initialize(selector=['./'])

        @selector = [*selector]
      end

      def _extract!(resources)

        return resources[:content].search(*@selector)
      end

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
