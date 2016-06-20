# -*- encoding : utf-8 -*-
require 'rails'
require 'rails_autolink'
require 'redcarpet'
require 'singleton'
require 'rouge'
require 'rouge/plugins/redcarpet'


module Redcarpet
  module Render
    class HTMLwithSyntaxHighlight < HTML
      
      include Rouge::Plugins::Redcarpet

      def initialize(extensions={})
        @syntax_converter = UltraMarkdown::SyntaxConverter.new({:is_rss => is_rss})


        super(extensions.merge(
          :xhtml => true,
          :no_styles => true,
          :filter_html => false,
          :hard_wrap => true
        ))
      end

      def preprocess(full_document)
        @syntax_converter.convert_bbcode_img(full_document)
        @syntax_converter.code_block(full_document)
        @syntax_converter.liquid_code_block(full_document)
        @syntax_converter.liquid_image_tag(full_document)
        @syntax_converter.liquid_blockquote(full_document)
        @syntax_converter.gist_tag(full_document)

        full_document
      end

      def postprocess(full_document)
        full_document
      end

      def block_code(code, language)
        @syntax_converter.render_octopress_like_code_block(language, code, nil, nil)
      end

      def codespan(code)
        @syntax_converter.codespan(code)
      end

      def image(link, title, alt_text)
        "<figure><img src=\"#{link}\" title=\"#{title}\" /></figure>"
      end


      def autolink(link, link_type)
        # return link
        if link_type.to_s == "email"
          ActionController::Base.helpers.mail_to(link, nil, :encode => :hex)
        else
          begin
            # 防止 C 的 autolink 出來的內容有編碼錯誤，萬一有就直接跳過轉換
            # 比如這句:
            # 此版本並非線上的http://yavaeye.com的源碼.
            link.match(/.+?/)
          rescue
            return link
          end
          # Fix Chinese neer the URL
          bad_text = link.match(/[^\w:\/\-\~\,\$\!\.=\?&#+\|\%]+/im).to_s
          link.gsub!(bad_text, '')
          "<a href=\"#{link}\" rel=\"nofollow\" target=\"_blank\">#{link}</a>#{bad_text}"
        end
      end

      # Topic 裡面，所有的 head 改為 h2 顯示
      def header(text, header_level, anchor = nil)
        header_level += 1
        "<h#{header_level}>#{text}</h#{header_level}>"
      end
    end

  end
end


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


