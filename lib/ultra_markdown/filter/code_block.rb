# -*- encoding : utf-8 -*-
require 'erb'
module UltraMarkdown
  module Filter
    module CodeBlock
      include ERB::Util
    
      # for code_block
      AllOptions = /([^\s]+)\s+(.+?)\s+(https?:\/\/\S+|\/\S+)\s*(.+)?/i
      LangCaption = /([^\s]+)\s*(.+)?/i
    
      # for liquid_code_block
      CaptionUrlTitle = /(\S[\S\s]*)\s+(https?:\/\/\S+|\/\S+)\s*(.+)?/i
      Caption = /(\S[\S\s]*)/
    
    
    
      # convert ```ruby title ```  like code block
      def code_block(input)
    
        input.gsub!(/^`{3} *([^\n]+)?\n(.+?)\n`{3}/m) do
          caption = nil
          options = $1 || ''
          lang = nil
          str = $2
    
          if options =~ AllOptions
            lang = $1
            caption = "<figcaption><span>#{$2}\n</span><a href='#{$3}'>#{$4 || 'link'}</a></figcaption>"
          elsif options =~ LangCaption
            lang = $1
            caption = "<figcaption><span>#{$2}\n</span></figcaption>"
          end
    
          if str.match(/\A( {4}|\t)/)
            str = str.gsub(/^( {4}|\t)/, '')
          end
    
          render_octopress_like_code_block(lang, str, caption, options)
        end
      end
    
    
      def liquid_code_block(input)
    
        input.gsub!(/^\{\% *codeblock([^\n\}]+)?\%\}.?\n?(.+?)\{\% *endcodeblock *\%\}/m) do
          caption = nil
          options = $1
          str = $2
          lang = nil
    
          if options =~ /\s*lang:(\S+)/i
            lang = $1
            options = options.sub(/\s*lang:(\S+)/i,'')
          end
    
          if options =~ CaptionUrlTitle
            file = $1
            caption = "<figcaption><span>#{$1}\n</span><a href='#{$2}'>#{$3 || 'link'}</a></figcaption>"
          elsif options =~ Caption
            file = $1
            caption = "<figcaption><span>#{$1}\n</span></figcaption>"
          end
          if file =~ /\S[\S\s]*\w+\.(\w+)/ && lang.nil?
            lang = $1
          end
    
          if str.match(/\A( {4}|\t)/)
            str = str.gsub(/^( {4}|\t)/, '')
          end
    
          render_octopress_like_code_block(lang, str, caption, options)
        end
      end
    
    
      def render_octopress_like_code_block(lang, str, caption, options)
        if is_rss
          code = block_code(str, "text")
          "<figure class='figure-code code'>#{caption}#{code}</figure>"
        elsif lang.nil? || lang == 'plain'
          code = block_code(str, nil)
          "<figure class='figure-code code'>#{caption}#{code}</figure>"
        elsif lang == 'mathjax'
          "<script type=\"math/tex; mode=display\">#{str}</script>"
        else
          if lang.include? "-raw"
            raw = "``` #{options.sub('-raw', '')}\n"
            raw += str
            raw += "\n```\n"
          else
            code = block_code(str, lang)
            "<figure class='figure-code code'>#{caption}#{code}</figure>"
          end
        end
      end
    
      def block_code(code, language)
        lexer = Rouge::Lexer.find(language)
        if lexer
          formatter = ::Rouge::Formatters::HTML.new(:wrap => true, :css_class => 'highlight', :wrapper_tag => "div" )
          formatter.format(lexer.lex(code))
        else
          render_plain(code)
        end
      end
    
      def render_plain(code)
        lexer = Rouge::Lexer.find("text")
         formatter = ::Rouge::Formatters::HTML.new(:wrap => true, :css_class => 'highlight', :wrapper_tag => "div" )
        formatter.format(lexer.lex(code))
      end

      def codespan(code)
        return "" if !code
    
        if code[0] == "$" && code[-1] == "$"
          code.gsub!(/^\$/,'')
          code.gsub!(/\$$/,'')
          "<script type=\"math/tex\">#{code}</script>"
        else
          "<code>#{ERB::Util.html_escape(code)}</code>"
        end
      end
    end
  end
end
