class SubscriptionsController < ApplicationController

  def index
    list
    render('list')
  end
  
  def list
    @subscriptions = Shipment.all
    @content = DynamicText.content("subscription")
  end
  
end
