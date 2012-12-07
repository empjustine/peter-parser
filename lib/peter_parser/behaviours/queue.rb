module PeterParser

  module RpcQueue
    require 'resque'

    module Worker

      # redis worker class entry point for PeterParser::Parser
      def perform(job=Hash.new)

        instance = self.new(job)
        return instance.run
      end
    end

    module EnqueueableHash

      # callback that enqueues all toplevel keys jobs to toplevel workers
      def enqueue(resources=nil)

        self.each { |field, jobs|
          next unless field.respond_to? :perform
          [*jobs].each { |job|
            Resque.enqueue(field, job)
          }
        }

        return resources
      end
    end
  end
end

# Single point of insertion for CorePatches::ListExtract
class Hash

  include PeterParser::RpcQueue::EnqueueableHash
end
