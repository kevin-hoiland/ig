class SubscriptionsController < ApplicationController

  def index
    list
    render('list')
  end
  
  def list
    @shipments = Shipment.page(params[:page]).order("date DESC")
    @content = DynamicText.content("subscription")
  end
  
end
