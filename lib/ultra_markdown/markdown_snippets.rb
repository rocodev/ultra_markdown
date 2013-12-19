# -*- encoding : utf-8 -*-
module UltraMarkdown
  module MarkdownSnippets
    UL = <<-EOS
    - item
    - item
    - item
    EOS

    OL = <<-EOS
    1. item
    2. item
    3. item
    EOS

    BLOCKQUOTE = <<-EOS
    > Quotation
    EOS


    MORE = <<-EOS
    <!--more-->
    EOS


    MORE_REGEX = /<!--\s*more\s*-->/i

    MATHJAX =  <<-EOS
    ```mathjax

    ```
    EOS
  end

end