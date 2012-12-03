#!/usr/bin/env ruby

def x(*args)

  return PeterParser::Components::NodesetSelector.new(*args)
end

class SaraivaParser < PeterParser::NodesetParser

  @queue = :low

  def default_job
    {
      'url' => 'http://www.livrariasaraiva.com.br/',
    }
  end

  def rules
    {
      SaraivaParser => x('//ul[@class="cima"]/li/a/@href').content,
    }.on(:after_extract, method(:enqueue))
  end
end
