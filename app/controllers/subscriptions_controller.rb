class SubscriptionsController < ApplicationController

  def index
    list
    render('list')
  end
  
  def list
    @shipments = Shipment.page(params[:page]).order("ship_date DESC")
    @content = DynamicText.content("subscription")
    @canceled_text = DynamicText.content("subs_canceled")
  end
  
end
