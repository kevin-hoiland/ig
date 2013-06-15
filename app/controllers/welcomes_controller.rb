class WelcomesController < ApplicationController
  
  before_filter do
    if request.ssl? && Rails.env.production?
      redirect_to :protocol => 'http://', :status => :moved_permanently
    end
  end
  
  def index
    @content_top = DynamicText.content("home_top").order("sequence ASC")
    @content_bottom = DynamicText.content("home_bottom").order("sequence ASC")
    @content_slide = DynamicText.content("home_slide").order("sequence ASC")
  end

  def faq
    @content = DynamicText.content("faq").order("sequence ASC")
  end
  
  def about
    @content = DynamicText.content("about").order("sequence ASC")
  end
  
  def contact_info
    @content = DynamicText.content("contact").order("sequence ASC")
  end
  
  def news
    @content= DynamicText.content("news").order("sequence DESC") # NEWS is backwards, largest numbers at top :-)
  end
  
  def corporate_info
    @content = DynamicText.content("corporate").order("sequence ASC")
  end
  
  def partners
    @content = DynamicText.content("partners").order("sequence ASC")
  end
  
  def shipping_policy
    @content = DynamicText.content("shipping").order("sequence ASC")
  end
  
  def returns_and_refunds
    @content = DynamicText.content("return").order("sequence ASC")
  end
  
  def privacy_and_security
    @content = DynamicText.content("privacy").order("sequence ASC")
  end
  
end
