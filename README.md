[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/empjustine/peter-parser)
# Overview

`PeterParser` is a parsing engine built on Ruby.

It currently supports HTML/XML parsing, but it's really easy to write plug-ins so that it parses different file structures. Native support for JSON and other file types will be added in the future, too.

To do the HTML/XML parsing it depends heavily on [Nokogiri](http://nokogiri.org/), future releases shall be more agnostic about this, adding the possibility of using other 'frameworks' in between.

I would heavily thank you for any feedback on anything related. Or not related.

# Usage

I'm putting a lot of effort into making `PeterParser` an easy and intuitive parsing engine. Once you get the basics it should be not difficult to assemble any kind of parser.

The first thing to do is defining a class which extends `PeterParser::NodesetParser` (sorry folks, the only kind of parser available right now):

    class MyParser < PeterParser::NodesetParser
    end

So, you now have your Parser (yuppie!) and you can now run it. You do that by, well, you know what? You call `PeterParser::NodesetParser.perform`:

Yep, it's that easy. Did you tried it? You did? It raised an error? What?

    #>>
        MyParser.perform
    #=> Exception: PeterParser::NoUrlError

Of course! In your urge to run our parser we forgot to tell it what will it be parsing! This can be done by passing a _job description_ (which is just a Hash, really) to it. By default, the only thing being passed through this Hash is the target URL, but there are some ways to pass further information. This will not be explained here, but on more advanced documents. So, this will work:

    MyParser.perform({'url' => 'http://www.example.com'})

Easy. Huh? Another error?

    #>>
        MyParser.perform({'url' => 'http://www.example.com'})
    #=> Exception: PeterParser::NoRulesError

Oh, well! Not only did we forget to tell our parser what is it going to parse, but also HOW it's going to do it. Thanks to ``PeterParser``, it's really, really, really easy to do that. All you have to do is define `rules` on your class. Try this:

    class MyParser < PeterParser::NodesetParser

      def rules

        'hello world!'
      end
    end

You can actually put anything on that extractor. Really, any instance of `Object`. The problem: most `Object`s will just be returned as-is. In order to do any meaningful processing, you have to plug there what I'll be calling _components_.

So what's a _component_? It's any object that's prepared to be processed by `PeterParser`. You see, Ruby interprets the _extractor_ at class-level and the parsing is done at instance-level (mostly, so that I can make sure that you can _run_ the same parser twice and get the same result - given, of course, the page does not change). So, every processing done over this _extractor_ is lazy: Ruby interprets the _extractor_ and just keeps in a queue everything that has to be done. Later, when the parsing really happens, this queue is consumed and it returns the result of the processing chain.

Back to _components_: along with a few nice out-of-the-box _components_, I've made sure that some Ruby native `Object`s (like `Array` and `Hash`) are _components_ too. This was done through some tweaking into those `Object`s (and the `Kernel` itself). I know it's not the best thing to do, but it's what they say: _"You can't make a lemonade without breaking a few eggs"_.

So, let's say I want to plug a `Hash` in my _extractor_:

    class MyParser < PeterParser::NodesetParser

      def rules
        {
          'phrase' => 'Hello World!',
          'a_number' => 2,
        }
      end
    end

We're still handling with things that are immutable: all values inside this `Hash` will be the same regardless of the page being parsed. In order to actually acquire information from pages (the actual parsing), enter an awesome thing called XPath (you can learn about it [here](http://www.w3schools.com/xpath/default.asp)) and the _component_ that handles them: `Selector` (actually, `PeterParser::Components::Selector`).

Let's say you want to get the _source_ for every image in a page. If you know XPath enough, you know that the XPath that brings you this is _'//img/@src'_. So, let's say I want to store these _sources_ under the `images` value on a `Hash`. The appropriate code would be:

    class MyParser < PeterParser::NodesetParser

      def rules
        {
          'images' => PeterParser::Components::Selector.new('//img/@src'),
        }
      end
    end
