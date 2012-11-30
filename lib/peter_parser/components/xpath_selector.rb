module PeterParser

  module Components

    class XpathSelector

      def initialize(selector='./', range=0..-1)

        @selector = selector
        @range = range
      end

      def _extract!(resources)

        return resources[:content].xpath(@selector)[@range]
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
