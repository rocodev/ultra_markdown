# -*- encoding : utf-8 -*-
require "ultra_markdown/filter/bbcode_image"
require "ultra_markdown/filter/block_quote"
require "ultra_markdown/filter/code_block"
require "ultra_markdown/filter/gist_tag"
require "ultra_markdown/filter/image_tag"
require "ultra_markdown/filter/result_sanitize"

module UltraMarkdown
  class SyntaxConverter
    include UltraMarkdown::Filter::CodeBlock
    include UltraMarkdown::Filter::BlockQuote
    include UltraMarkdown::Filter::BbcodeImage
    include UltraMarkdown::Filter::ImageTag
    include UltraMarkdown::Filter::GistTag

    def initialize(options={})
      @options = options
    end

    def is_rss
      if !@options[:is_rss]
        return false
      else
        return @options[:is_rss]
      end

    end


  end

end