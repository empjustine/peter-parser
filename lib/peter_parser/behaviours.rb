module PeterParser

  # Implements a Web Scraper based on Mechanize and Nokogiri. Plumbing from
  # these gems are exposed by the resources hash, under :agent and :page keys.
  module WebScraper
    require 'mechanize'
    require 'logger'

    # Initialize Mechanize agent to parse page.
    def agent(resources)

      resources[:agent] ||= Mechanize.new() { |_agent|
        _agent.user_agent_alias = 'Mac Safari'

      # _agent.log = Logger.new $stderr
      # _agent.agent.http.debug_output = $stderr
      }

      return resources[:agent]
    end

    # Tell Mechanize to fetch a url.
    def fetch(resources)

      raise NoUrlError unless resources['url']

      return resources[:page] = agent(resources).get(
        URI resources['url']
      )
    end

    # Asks for page Nokogiri nodeset.
    def content(resources)

      return resources[:content] = resources[:page].root
    end
  end
end
