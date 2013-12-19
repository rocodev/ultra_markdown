# -*- encoding : utf-8 -*-
class String
	def to_markdown
		content = self
		return "" if content.blank?

    UltraMarkdown::MarkdownProcessor.compile(content).html_safe
  end

  def to_markdown_for_rss
    content = self
    return "" if content.blank?

    UltraMarkdown::MarkdownProcessor.compile_for_rss(content).html_safe
  end



  def to_markdown_preview(current_line = 1)
    return to_markdown if current_line == 1

    content = self
    mirror_content = content.clone
    random_seed = (0...16).map{ ('a'..'z').to_a[rand(26)] }.join

    mirror_content = insert_to_specific_line(mirror_content, current_line, random_seed)
    mirror_content_markdown = mirror_content.to_markdown
    pivot_line = find_text_in_line(mirror_content_markdown, random_seed)

    insert_to_specific_line(content.to_markdown, pivot_line, "<span class=\"preview-target\"> </span>")
  end


  def excerpt
    if self.index(UltraMarkdown::MarkdownSnippets::MORE_REGEX)
      self.split(UltraMarkdown::MarkdownSnippets::MORE_REGEX)[0].try(:html_safe)
    else
      self
    end
  end



  private



  def insert_to_specific_line(mirror_content = "", current_line = 0, insert_text)
    output = ""
    line_num = 0

    mirror_content.each_line do |line|
      line_num += 1
      if (line_num == current_line)
        output += insert_text + line
      else
        output += line
      end
    end
    
    output
  end

  def find_text_in_line(mirror_content_markdown = "", text)
    line_num = 0

    mirror_content_markdown.each_line do |line|
      line_num += 1
      return line_num if line[text]
    end
  end



end

