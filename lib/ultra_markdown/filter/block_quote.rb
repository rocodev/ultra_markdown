# -*- encoding : utf-8 -*-
module UltraMarkdown

  module Filter
    module BlockQuote
  
      FullCiteWithTitle = /(\S.*)\s+(https?:\/\/)(\S+)\s+(.+)/i
      FullCite = /(\S.*)\s+(https?:\/\/)(\S+)/i
      AuthorTitle = /([^,]+),([^,]+)/
      Author =  /(.+)/
    
    
      def liquid_blockquote(input)
    
        input.gsub!(/^\{\% *blockquote([^\n\}]+)?\%\} ?\n?(.+?)\n?\{\% *endblockquote *\%\}/m) do
          markup = $1
          content = $2
          by = nil
          source = nil
          title = nil
          author = nil
    
          if markup =~ FullCiteWithTitle
            by = $1
            source = $2 + $3
            title = $4.titlecase.strip
          elsif markup =~ FullCite
            by = $1
            source = $2 + $3
          elsif markup =~ AuthorTitle
            by = $1
            title = $2.titlecase.strip
          elsif markup =~ Author
            by = $1
          end
    
          quote = "<p>#{content.lstrip.rstrip.gsub(/\n\s*\n/, '</p><p>').gsub(/\n/, '<br/>')}</p>"
          author = "<strong>#{by.strip}</strong>" if by && !by.blank?
    
          if source
            url = source.match(/https?:\/\/(.+)/)[1].split('/')
            parts = []
            url.each do |part|
              if (parts + [part]).join('/').length < 32
                parts << part
              end
            end
            source_temp = parts.join('/')
            source << '/&hellip;' if source_temp != source
          end
    
          if !source.nil?
            cite = " <cite><a href='#{source}'>#{(title || source)}</a></cite>"
          elsif !title.nil?
            cite = " <cite>#{title}</cite>"
          end
    
          blockquote = "<blockquote>#{quote}</blockquote>"
          caption = ""
          caption = "<figcaption>&mdash; #{author}#{cite}</figcaption>" if author or cite
    
          "<figure class='figure-quote'>#{blockquote}#{caption}</figure>"
        end
      end
    end
  
  end
end
  