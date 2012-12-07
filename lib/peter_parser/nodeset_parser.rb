module PeterParser

  # Actually gets things done.
  # Seriously this implements basic callback behaviour to get the HTML and parse
  # it. What you do with whatever comes out from it it's your fault.
  class NodesetParser

    include PeterParser::WebScraper
    extend  PeterParser::RpcQueue::Worker

    # Acessor to the job's resource, while it's in pipe transit system.
    attr_reader :resource

    # Takes a parser class and prepare job's resources
    #
    # job accepts both an Hash(recomended) or a string (a lazy kludge, mostly
    # meant for testing environments. and some legacy parsers we keep around).
    def initialize(job=Hash.new)

      @resource = {}

      job = { 'url' => job } if job.is_a? String

      [default_job, job].each { |raw_resource|
        raw_resource.each { |k, v|
          @resource[k] = v
        }
      }

      inject_callbacks
    end

    # Ask the current behaviour (PeterParser::WebScraper) to actually fetch the
    # resources.
    def _40__nodeset_parser__before_extract__callback(resources)

      fetch(resources)

      return resources
    end

    # Ask the current behaviour (PeterParser::WebScraper) to parse page's
    # contents.
    def _50__nodeset_parser__before_extract__callback(resources)

      content(resources)

      return resources
    end

    # Definition of a task. Should accept the #extract call.
    def rules

      raise PeterParser::NoRulesError
    end

    # Default job, when none given.
    def default_job

      return {}
    end

    # Definition of what to extract inside worker.
    def _extract!(resources)

      return rules.extract(resources)
    end

    # Entry point for really start parsing the page.
    def run

      return @resource[:data] = extract(@resource)
    end
  end
end
