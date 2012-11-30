module PeterParser

  module RpcQueueWorker
    require 'resque'

    # redis worker class entry point for PeterParser::Parser
    def perform(job={})

      instance = self.new(job)
      return instance.run
    end
  end

  module RpcQueueEnqueuer
    require 'resque'

    # callback that adds jobs to queue
    def enqueue(resources)

      puts resources.inspect

      resources.each { |field, jobs|
        next unless field.is_a? Class
        jobs.each { |job|
          Resque.enqueue(field, job)
        }
      }

      return resources
    end
  end
end
