module PeterParser

  module WebScraper
    require 'mechanize'
    require 'logger'

    # initialize Mechanize agent to parse page
    def agent(resources)

      resources[:agent] ||= Mechanize.new() { |_agent|
        _agent.user_agent_alias = 'Mac Safari'

      # _agent.log = Logger.new $stderr
      # _agent.agent.http.debug_output = $stderr
      }

      return resources[:agent]
    end

    # tell Mechanize to fetch a url
    def fetch(resources)

      return resources[:page] = agent(resources).get(
        URI resources['url']
      )
    end

    # asks for page nodeset
    def content(resources)

      return resources[:content] = resources[:page].root
    end
  end

  module JsonParser
    require 'json'

    # parses page content. meant to replace PeterParser::WebScraper for json
    # requests
    def content(resources)

      return resources[:content] = JSON.parse(
        resources[:page].body
      )
    end
  end
end
