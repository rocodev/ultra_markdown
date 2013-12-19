# -*- encoding : utf-8 -*-
module UltraMarkdown
  module Filter
    module ImageTag
      def liquid_image_tag(input)
        attributes = ['class', 'src', 'width', 'height', 'title']
        img = nil
  
  
        input.gsub!(/^\{\% *img ([^\n\}]+)\%\}/m) do
          markup = $1
  
          if markup =~ /(?<class>\S.*\s+)?(?<src>(?:https?:\/\/|\/|\S+\/)\S+)(?:\s+(?<width>\d+))?(?:\s+(?<height>\d+))?(?<title>\s+.+)?/i
            img = attributes.reduce({}) { |img_temp, attr| img_temp[attr] = $~[attr].strip if $~[attr]; img_temp }
            if /(?:"|')(?<title>[^"']+)?(?:"|')\s+(?:"|')(?<alt>[^"']+)?(?:"|')/ =~ img['title']
              img['title'] = title
              img['alt'] = alt
            else
              if img['title']
                img['title'].gsub!(/"/, '&#34;')
                img['alt'] = img['title']
              end
            end
            img['class'].gsub!(/"/, '') if img['class']
          end
  
          "<img #{img.collect {|k,v| "#{k}=\"#{v}\"" if v}.join(" ")}>"
        end
      end
    end
  end
end