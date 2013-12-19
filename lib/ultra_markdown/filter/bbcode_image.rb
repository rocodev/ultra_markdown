module UltraMarkdown

  module Filter
    module BbcodeImage

     # convert bbcode-style image tag [img]url[/img] to markdown syntax ![alt](url)
     def convert_bbcode_img(text)
       text.gsub!(/\[img\](.+?)\[\/img\]/i) {"![#{image_alt $1}](#{$1})"}
     end

     def image_alt(src)
       File.basename(src, '.*').capitalize
     end
     
    end
  end

end