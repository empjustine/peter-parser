module PeterParser

  # Actually gets things done.
  # Seriously this implements basic callback behaviour to get the HTML and parse
  # it.
  class NodesetParser

    include PeterParser::WebScraper
    extend  PeterParser::RpcQueueWorker
    include PeterParser::RpcQueueEnqueuer

    attr_reader :resource

    # takes a class parser declaration and prepare a job resources
    def initialize(job=Hash.new)

      @resource = {}

      # lazy kludge, mostly for testing environments. and some legacy parsers.
      job = { 'url' => job } if job.is_a? String

      [default_job, job].each { |raw_resource|
        raw_resource.each { |k, v|
          @resource[k] = v
        }
      }

      _inject_callbacks
    end

    # default http/nodeset type resource fetching, integrated using the callback
    # system. a example implementation of "ordered and namespaced event system
    # injected callback methods"
    def _50__nodeset_parser__before_extract__callback(resources)

      fetch(resources)
      content(resources)
      return resources
    end

    # definition of a task. should accept the #extract call
    def rules

      raise PeterParser::NoRulesError
    end

    # default job, when none given. most times should be overridden.
    def default_job

      return {}
    end

    # definition of what to extract inside worker
    def _extract!(resources)

      return rules.extract(resources)
    end

    # entry point for really start parsing the page
    def run

      return @resource[:data] = extract(@resource)
    end
  end
end
