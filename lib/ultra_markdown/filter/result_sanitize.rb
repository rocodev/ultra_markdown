# -*- encoding : utf-8 -*-
module UltraMarkdown
  module Filter
    module ResultSanitize
  
      ScriptTransformer = lambda do |env|
        node      = env[:node]
        node_name = env[:node_name]
    
        return if env[:is_whitelisted] || !node.element?
        return if node_name != 'script'
    
        is_not_mathtex = node[:type] != "math/tex; mode=display"
        is_not_gist = (node['src'] =~ /\Ahttps:\/\/(?:gist\.)?github(?:-nocookie)?\.com\//) == nil
        is_not_speakerdeck = (node['src'] =~ /\A(https?:)?\/\/(?:www\.)?speakerdeck(?:-nocookie)?\.com\//) == nil
    
        return if is_not_mathtex && is_not_gist && is_not_speakerdeck
    
        {:node_whitelist => [node]}
      end
    
    
      CommentTransformer = lambda do |env|
        node      = env[:node]
        node_name = env[:node_name]
    
        return if env[:is_whitelisted]
        return if node_name != 'comment'
    
        is_not_more = (node.content =~ /^\s*more\s*$/i) == nil
    
        return if is_not_more
    
        {:node_whitelist => [node]}
      end
    
    
    
    
    
      SanitizeSetting = {
          :elements => %w[
            a abbr b bdo blockquote br caption cite code col colgroup dd del dfn dl
            dt em figcaption figure h1 h2 h3 h4 h5 h6 hgroup i img ins kbd li mark
            ol p pre q rp rt ruby s samp small strike strong sub sup table tbody td
            tfoot th thead time tr u ul var wbr span iframe hr
          ],
    
          :attributes => {
            :all         => ['dir', 'lang', 'title', 'class'],
            'a'          => ['href'],
            'blockquote' => ['cite'],
            'col'        => ['span', 'width'],
            'colgroup'   => ['span', 'width'],
            'del'        => ['cite', 'datetime'],
            'img'        => ['align', 'alt', 'height', 'src', 'width'],
            'ins'        => ['cite', 'datetime'],
            'ol'         => ['start', 'reversed', 'type'],
            'q'          => ['cite'],
            'table'      => ['summary', 'width'],
            'td'         => ['abbr', 'axis', 'colspan', 'rowspan', 'width'],
            'th'         => ['abbr', 'axis', 'colspan', 'rowspan', 'scope', 'width'],
            'time'       => ['datetime', 'pubdate'],
            'ul'         => ['type'],
            'iframe'     => ['allowfullscreen', 'frameborder', 'height', 'src', 'width']
          },
    
          :protocols => {
            'a'          => {'href' => ['ftp', 'http', 'https', 'mailto', :relative]},
            'blockquote' => {'cite' => ['http', 'https', :relative]},
            'del'        => {'cite' => ['http', 'https', :relative]},
            'img'        => {'src'  => ['http', 'https', :relative]},
            'ins'        => {'cite' => ['http', 'https', :relative]},
            'q'          => {'cite' => ['http', 'https', :relative]}
          },
    
          :transformers => [
            ScriptTransformer,
            CommentTransformer
          ]
      }
    
    
      def self.clean(str)
        Sanitize.clean(str, SanitizeSetting)
      end
    end
  
  end
end
