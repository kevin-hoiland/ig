module ApplicationHelper
  
  def title(page_title)
    content_for(:title) { page_title }
  end
  
  def description(page_description)
    content_for(:description) { page_description }
  end
  
  def permalink_humanize(permalink)
    permalink.gsub("_", " ").titleize
  end
  
  def legalize(text)
    map = {'(TM)' => '&#8482;', '(R)' => '&#174;', '(C)' => '&#169;'}
    re = Regexp.new(map.keys.map { |x| Regexp.escape(x) }.join('|'))
    text.gsub(re, map).html_safe
  end
    
end
