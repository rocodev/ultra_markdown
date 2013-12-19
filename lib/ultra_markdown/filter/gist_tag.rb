# -*- encoding : utf-8 -*-
module UltraMarkdown
  module Filter
    module GistTag

      def script_url_for(gist_id, filename)
        url = "https://gist.github.com/#{gist_id}.js"
        url = "#{url}?file=#{filename}" unless filename.nil? or filename.empty?
        url
      end

      def gist_tag(input)
        input.gsub!(/^\{\% *gist ([^\n\}]+)\%\}/m) do
          markup = $1

          if markup =~ /([a-zA-Z\d]*) (.*)/
            gist = $1
            file = $2.strip if $2

            script_url = script_url_for(gist, file)

            "<script src='#{script_url}'> </script>"
          end

        end
      end
    end
  end
end