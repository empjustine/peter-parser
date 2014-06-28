module PeterParser

  # Actually gets things done.
  # Seriously this implements basic callback behaviour to get the HTML and parse
  # it. What you do with whatever comes out from it it's your fault.
  class StatefulParser < RepresentationalStateTransferParser

    # Ask the current behaviour (PeterParser::WebScraper) to actually fetch the
    # resources.
    def _40__nodeset_parser__before_bootstrap__callback(resources)

      fetch(resources)

      return resources
    end

    # Ask the current behaviour (PeterParser::WebScraper) to parse page's
    # contents.
    def _50__nodeset_parser__before_bootstrap__callback(resources)

      content(resources)

      return resources
    end

    # Everything needed in order to bootstrap a stateful job.
    # Should accept the #extract call.
    def bootstrap

      raise PeterParser::NoManifestError
    end

    # Definition of what to extract inside worker.
    def _extract!(resources)

      bootstrap.extract(resources)
      while resources
        manifest.extract(resources)
      end
    end

    # Entry point for really start parsing the page.
    # Method called by RPC's call
    def run

      return @resource[:data] = extract(@resource)
    end
  end

  RestfulParser = RepresentationalStateTransferParser
end
