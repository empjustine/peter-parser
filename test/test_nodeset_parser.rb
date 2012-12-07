require 'mock_redis'
require 'webmock/test_unit'


Resque.redis = MockRedis.new

class EmptyNodesetParser < PeterParser::NodesetParser
end

class ExampleNodesetParser < PeterParser::NodesetParser

  def rules

    PeterParser::Components::NodesetSelector.new('//h1').content
  end
end

class ExampleNodesetParser2 < PeterParser::NodesetParser

  def rules
    {
      :first => PeterParser::Components::NodesetSelector.new('//link[@rel="stylesheet"]/@href').content.first,
      :last => PeterParser::Components::NodesetSelector.new('//link[@rel="stylesheet"]/@href').content.last,
    }
  end
end

class EnqueuingNodesetParser < PeterParser::NodesetParser

  @queue = :test

  def rules
    {
      EnqueuingNodesetParser => PeterParser::Components::NodesetSelector.new('//a/@href').content
    }.on(:after_extract, :enqueue)
  end
end

class TestNodesetParser < Test::Unit::TestCase

  def test_empty_parser

    assert_raise(PeterParser::NoUrlError) {
      EmptyNodesetParser.perform
    }

    stub_request(:get, "http://www.iana.org/domains/example/").to_return(File.open('test/assets/example.html'))
    assert_raise(PeterParser::NoRulesError) {
      EmptyNodesetParser.perform('http://www.iana.org/domains/example/')
    }
  end

  def test_nodeset_selector_content

    stub_request(:get, "http://www.iana.org/domains/example/").to_return(File.open('test/assets/example.html'))
    assert_equal(["Example Domains"], ExampleNodesetParser.perform('http://www.iana.org/domains/example/'))
  end

  def test_nodeset_selector_first

    stub_request(:get, "http://www.iana.org/domains/example/").to_return(File.open('test/assets/example.html'))
    assert_equal({:first => "/_css/2008.1/reset-fonts-grids.css", :last => "/_css/2008.1/print.css"}, ExampleNodesetParser2.perform('http://www.iana.org/domains/example/'))
  end

  def test_resque_enqueuing

    stub_request(:get, "http://www.iana.org/domains/example/").to_return(File.open('test/assets/example.html'))
    assert(EnqueuingNodesetParser.perform('http://www.iana.org/domains/example/'))
  end
end

