module PeterParser

  module Components

    #Value object used to extract nodes from nodesets using XPath or CSS.
    class NodesetSelector

      def initialize(selector=['./'], range=0..-1)

        @selector = [*selector]
        @range = range
      end

      def _extract!(resources)

        return resources[:content].search(*@selector)[@range]
      end

      def first

        @range = 0
      end

      def content

        on(:after_extract) { |element|
          element.map(&:content)
        }
      end
    end
  end
end
