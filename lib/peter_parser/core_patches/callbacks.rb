module PeterParser

  module CorePatches

    module Callbacks

      def callbacks(event=nil)

        @callbacks ||= {}
        return !event ? @callbacks : @callbacks[event] ||= []
      end

      # call all registered callback methods for an event
      def trigger(event, resources)

        callbacks(event).each { |callback|
          resources = callback.call(resources)
        }

        return resources
      end

      # call all registered callback methods for several events
      def trigger_pipeline(events, resources)

        events.each { |event|
          resources = trigger(event, resources)
        }

        return resources
      end

      # appends decorated method names to callback system
      def _inject_callbacks

        methods.sort.each { |m|
          match = m.to_s.match(/^_(.*)__(.*)__(.*)__callback$/)
          if match
            name, _order, _namespace, event = match.to_a
            on(event.to_sym, name.to_sym)
          end
        }
      end

      # add callback block to element. returns self to allow chaining
      def on(event, _method=nil, &block)

        _method = method(_method) if _method.is_a? Symbol
        _method ||= block
        callbacks(event) << _method if _method

        return self
      end
    end
  end
end

#single point of insertion for CorePatches::Callbacks
class Object

  include PeterParser::CorePatches::Callbacks
end
