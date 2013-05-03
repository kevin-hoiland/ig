module ApplicationHelper
  
  def title(page_title)
    content_for(:title) { remove_legals(page_title).html_safe }
  end
  
  def description(page_description)
    content_for(:description) { remove_legals(page_description).html_safe }
  end
  
  def permalink_humanize(permalink)
    permalink.gsub("_", " ").titleize
  end
  
  def legalize(text)
    map = {'(TM)' => '&#8482;', '(R)' => '&#174;', '(C)' => '&#169;'}
    re = Regexp.new(map.keys.map { |x| Regexp.escape(x) }.join('|'))
    text.gsub(re, map).html_safe
  end
  
  def remove_legals(text)
    map = {'(TM)' => '', '(R)' => '', '(C)' => ''} # note for SEO, removing legal context in titles. also note, if (TM) or other has spaces on both sides, will result in double space :(
    re = Regexp.new(map.keys.map { |x| Regexp.escape(x) }.join('|'))
    text.gsub(re, map)    
  end
    
end
