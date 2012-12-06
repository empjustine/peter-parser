module PeterParser

  module RpcQueueWorker
    require 'resque'

    # redis worker class entry point for PeterParser::Parser
    def perform(job=Hash.new)

      instance = self.new(job)
      return instance.run
    end
  end

  module RpcQueueEnqueuer
    require 'resque'

    # callback that enqueues all toplevel keys jobs to toplevel workers
    def enqueue(resources)

      resources.each { |field, jobs|
        next unless field.respond_to? :perform
        jobs.each { |job|
          Resque.enqueue(field, job)
        }
      }

      return resources
    end
  end
end
