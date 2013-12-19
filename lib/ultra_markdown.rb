require "ultra_markdown/version"
require "ultra_markdown/markdown_processor"
require "ultra_markdown/syntax_convertor"
require "ultra_markdown/markdown_snippets"

case ::Rails.version.to_s
when /^4/
  require 'ultra_markdown/engine'
when /^3\.[12]/
  require 'ultra_markdown/engine3'
when /^3\.[0]/
  require 'ultra_markdown/railtie'
end

module UltraMarkdown

  class HTMLforPost < Redcarpet::Render::HTMLwithSyntaxHighlight
    def is_rss
      false
    end
  end

  class HTMLforRSS < Redcarpet::Render::HTMLwithSyntaxHighlight
    def is_rss
      true
    end
  end

  class MarkdownProcessor
    include Singleton

    def initialize
      options = {
        :autolink => true,
        :strikethrough => true,
        :space_after_headers => false,
        :tables => true,
        :lax_spacing => true,
        :no_intra_emphasis => true,
        :footnotes => true
      }

      @converter = Redcarpet::Markdown.new(HTMLforPost.new, options)
      @converter_for_rss = Redcarpet::Markdown.new(HTMLforRSS.new, options)
    end

    def self.compile(raw)
      self.instance.format(raw)
    end

    def self.compile_for_rss(raw)
      self.instance.format(raw, true)
    end


    def format(raw, is_rss = false)
      text = raw.clone
      return '' if text.blank?

      result = if is_rss
        @converter_for_rss.render(text)
      else
        @converter.render(text)
      end

      #result = Modules::ResultSanitize.clean(result)

      doc = Nokogiri::HTML.fragment(result)

      return doc.to_html
    rescue => e
      Airbrake.notify(e)
      puts "MarkdownTopicConverter.format ERROR: #{e}"
      return text
    end



    private

  end
end



