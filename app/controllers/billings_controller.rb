class BillingsController < ApplicationController
  
  require 'active_merchant'
  ActiveMerchant::Billing::Base.mode = :development
  
  before_filter :authenticate_user!

#######################################################################  

#  require 'rubygems'
  
  LOGIN_ID = '5Eh4LJew5B'
  #TRANSACTION_KEY = '6SyY69r5Gs4X2Aas'
  TRANSACTION_KEY = '8yJd9v477GfKaR73'



#######################################################################  

  def index
    list
    render('list')
  end
  
  def list
   @subscription_list = Kaminari.paginate_array(Billing.find_all_by_user_id(current_user.id, :order => 'created_at ASC')).page(params[:page])
   # @search_subscriptions = Billing.ransack(params[:q])
   # @subscription_list = @search_subscriptions.result.order("updated_at ASC").page(params[:page]).per(5)
  end
  
  def new
    @billing = Billing.new
    @content_top = DynamicText.content("billing_top")
    @content_bottom = DynamicText.content("billing_bottom")
  end
  
  def edit
    @billing = Billing.find_by_user_id_and_subscription_number(current_user.id, params[:id])
    @content_top = DynamicText.content("billing_top")
    @content_bottom = DynamicText.content("billing_bottom")
  end

  def create
    @billing = Billing.new
    @billing.user_id = current_user.id
    set_values(params[:billing])
    profile = Profile.find_by_user_id(current_user.id)
    @billing.subscription_number = profile.subscriptions_created + 1
    creditcard = ActiveMerchant::Billing::CreditCard.new(@payment_info)
    if creditcard.valid?
      #if @billing.save
      if @billing.valid?
        #profile.subscriptions_created += 1
        #profile.save
        creditcard = ActiveMerchant::Billing::CreditCard.new(@payment_info)
        gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(:login => LOGIN_ID, :password => TRANSACTION_KEY, :test => true)
#        options = {:interval => { :unit => :months, :length => 1 }, :duration => { :start_date => get_start_date, :occurrences => 9999},
#                  :ip => @ip, :customer => @customer, :email => @email, :description => 'New monthly recurring Subscription for $8 per month.',
#                  :shipping_address => @shipping_address, :billing_address => @billing_address}
        options = {:ip => @ip, :description => 'New monthly recurring Subscription for $8 per month.',
                    :interval => { :unit => :months, :length => 1 }, :duration => { :start_date => get_start_date, :occurrences => 9999},
                    :customer => @customer, :shipping_address => @shipping_address, :billing_address => @billing_address}
        response = gateway.authorize(800, creditcard, options) # this is the temporary one charge type for testing
        # this is the recurring one below (can't use it in test mode)
        #response = gateway.recurring(800, creditcard, options)
        
        if response.success?
          #gateway.capture(800, response.authorization)
          
          # Below is used when processing recuring (gateway returns a token for representing recurring value)
          #@billing.pan_token = response.params["subscription_id"]
          @billing.gateway_subscriber_id = response.params["subscription_id"]
          
          #@billing.cvc = 123 # hack to save billing
          #IF BILLING SAVE....    ############################### (add code here)
          @billing.save
          profile.subscriptions_created += 1
          profile.save
          #
          flash[:alert] = "Success: " + response.message.to_s
          flash[:notice] = "Gumgratulations, new Subscription Created! Your Active Subscription count is now: #{profile.subscriptions_created-profile.subscriptions_deleted}"
          redirect_to(list_billings_url)
        else
          flash[:alert] = "Unable to Create Subscription: " + response.message.to_s
          #profile.subscriptions_created -= 1
          #profile.save
          #@billing.destroy
          @content_top = DynamicText.content("billing_top")
          @content_bottom = DynamicText.content("billing_bottom")
          render('new')  
        end
      else
        flash[:alert] = "Unable to Create New Subscription"
        @content_top = DynamicText.content("billing_top")
        @content_bottom = DynamicText.content("billing_bottom")
        render('new')
      end
    else 
      #flash[:alert] = "Credit card not valid: "+creditcard.validate.to_s
      flash[:alert] = "Credit card not valid: #{creditcard.errors.full_messages.join('. ')}"
      #profile.subscriptions_created -= 1
      #profile.save
      #@billing.destroy
      @content_top = DynamicText.content("billing_top")
      @content_bottom = DynamicText.content("billing_bottom")
      render('new')    
    end
  end
  
  def update
    #@billing = Billing.find_by_user_id(current_user.id)
    @billing = Billing.find_by_user_id_and_subscription_number(current_user.id, params[:id])
    set_values(params[:billing])
    profile = Profile.find_by_user_id(current_user.id)
    #@billing.subscription_number = profile.subscription_count + 1
    if @billing.save
      #profile.subscription_count += 1
      if profile.save
        flash[:notice] = "Your Subscription was updated successfully!"
      else    #  DUDE, THIS SHOULD NEVER HAPPEN, DOUBLE CHECK AND WRITE APPROPRIATE HANDLING ETC
        flash[:alert] = "Error, with #{profile.subscription_count} Subscriptions counted!"
      end
      redirect_to(list_billings_url)
    else
      flash[:alert] = "Unable to Update Subscription Info"
      @content_top = DynamicText.content("billing_top")
      @content_bottom = DynamicText.content("billing_bottom")
      render('edit')
    end
  end  

  def delete_confirmation
    #@billing = Billing.find(params[:id])
    @billing = Billing.find_by_user_id_and_subscription_number(current_user.id, params[:id])
    @content = DynamicText.content("billing_delete")
  end
  
  def destroy
    #billing = Billing.find(params[:id])
    billing = Billing.find_by_user_id_and_subscription_number(current_user.id, params[:id])
    profile = Profile.find_by_user_id(current_user.id)
    if billing.destroy
      profile.subscriptions_deleted += 1
      if profile.save
        flash[:notice] = "Your Subscription was deleted successfully!"
      else
        flash[:alert] = "Error, you Profile was not updated with deleted subscription count" # <----  WHAT THE HECK IS THIS SCENARIO???!!!????
      end
      log = DeletedObject.new
      log.deleted_type = "Subscription"
      log.reason = params[:billing][:reason]
      log.user_id = current_user.id
      log.email = current_user.email
      log.profile_id = profile.id
      log.subscription_id = billing.id
      log.last_four = billing.last_four
      log.bill_last_name = billing.bill_last_name
      log.ship_name = billing.ship_first_name+" "+billing.ship_last_name
      log.original_creation_dt = billing.created_at
      log.save
      redirect_to(list_billings_url)
    else
      flash[:alert] = "Unable to Delete Your Subscription"
      redirect_to(list_billings_url)
    end
  end
  
private

  def set_values (billing_info)
    @billing.subscription_name = billing_info[:subscription_name]
    @billing.ship_first_name = billing_info[:ship_first_name]
    @billing.ship_last_name = billing_info[:ship_last_name]
    @billing.ship_street = billing_info[:ship_street]
    @billing.ship_city = billing_info[:ship_city]
    @billing.ship_state_province = billing_info[:ship_state_province]
    @billing.ship_postal_code = billing_info[:ship_postal_code]
    @billing.ship_country = billing_info[:ship_country]
    @billing.bill_street = billing_info[:bill_street]
    @billing.bill_city = billing_info[:bill_city]
    @billing.bill_state_province = billing_info[:bill_state_province]
    @billing.bill_postal_code = billing_info[:bill_postal_code]
    @billing.bill_country = billing_info[:bill_country]
    @billing.bill_first_name = billing_info[:bill_first_name]
    @billing.bill_last_name = billing_info[:bill_last_name]
    @billing.expiry_month = billing_info[:expiry_month]
    @billing.expiry_year = billing_info[:expiry_year]
    @billing.cvc = billing_info[:cvc]
    @billing.pan = billing_info[:pan].gsub(/[^0-9]/, "")
    @billing.terms = billing_info[:terms]
    if @billing.pan > ""  # Only update the last_four DB value from pan attribute accessor if something exists for pan
      @billing.last_four = @billing.pan.to_s.slice(-4..-1)
    end
    @ip = User.find(@billing.user_id).current_sign_in_ip
    #@customer = {:id => @billing.user_id.to_i, :email => User.find(@billing.user_id).email}
    #@customer = {:id => b.user_id.to_s+":"+b.subscription_number.to_s, :email => User.find(@billing.user_id).email}      
    @customer = {:id => @billing.user_id.to_s+":"+@billing.subscription_number.to_s, :email => User.find(@billing.user_id).email}      

    #@email = User.find(@billing.user_id).email
    @billing_address = { :first_name => @billing.bill_first_name, :last_name => @billing.bill_last_name,
        :address1 => @billing.bill_street, :city => @billing.bill_city, :state => @billing.bill_state_province,
        :country => @billing.bill_country, :zip => @billing.bill_postal_code }
    @shipping_address = { :first_name => @billing.ship_first_name, :last_name => @billing.ship_last_name,:address1 => @billing.ship_street, :city => @billing.ship_city,
        :state => @billing.ship_street, :country => @billing.ship_country, :zip => @billing.ship_postal_code }
    @payment_info = {:number => @billing.pan, :verification_value => @billing.cvc, :month => @billing.expiry_month.slice(0..1).to_i,
        :year => @billing.expiry_year, :first_name => @billing.bill_first_name, :last_name => @billing.bill_last_name,
        :brand => 'visa'} #BRAND IS STILL STATIC...
  end


  def get_start_date      
    if Date.today.day >= 8                                # ... too late for the current month's subscription
      if Date.today.month == 12                           # ... if it's December, subscription starts next "year"
        Date.new(Date.today.year+1,Date.today.month+1,8)
      else                                                # ... if it's NOT December, subscription starts current "year"
        Date.new(Date.today.year,Date.today.month+1,8)
      end
    else                                                  # ... still early enough for current month's subscription
      Date.new(Date.today.year,Date.today.month,8)
    end
  end

end

=begin OLD WAY OF CREATING PAYMENT
def new_payment_account(ip, customer, email, shipping_address, billing_address, payment_info)
  charge_amount = 800
  creditcard = ActiveMerchant::Billing::CreditCard.new(payment_info)
  gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(:login => LOGIN_ID, :password => TRANSACTION_KEY, :test => true)
  
  if creditcard.valid?
    options = {:ip => ip, :customer => customer, :email => email, :description => 'New monthly recurring Subscription for $8 per month.', :shipping_address => shipping_address, :billing_address => billing_address}
    response = gateway.authorize(charge_amount, creditcard, options)

    if response.success?
      gateway.capture(charge_amount, response.authorization)
      flash[:notice] = "Success: " + response.message.to_s
      #puts "Success: " + response.message.to_s
    else
      #puts "Fail: " + response.message.to_s
      flash[:alert] = "Fail: " + response.message.to_s  
    end
  else
    #puts "Credit card not valid: " + creditcard.validate.to_s
    flash[:alert] = "Credit card not valid: " + creditcard.validate.to_s
  end
end
  
end
=end


# OLD CONTENT FROM CREATE
=begin
    @billing.subscription_name = params[:billing][:subscription_name]
    @billing.ship_name = params[:billing][:ship_name]
    @billing.ship_street = params[:billing][:ship_street]
    @billing.ship_city = params[:billing][:ship_city]
    @billing.ship_state_province = params[:billing][:ship_state_province]
    @billing.ship_postal_code = params[:billing][:ship_postal_code]
    @billing.ship_country = params[:billing][:ship_country]
    @billing.bill_street = params[:billing][:bill_street]
    @billing.bill_city = params[:billing][:bill_city]
    @billing.bill_state_province = params[:billing][:bill_state_province]
    @billing.bill_postal_code = params[:billing][:bill_postal_code]
    @billing.bill_country = params[:billing][:bill_country]
    @billing.bill_first_name = params[:billing][:bill_first_name]
    @billing.bill_middle_name = params[:billing][:bill_middle_name]
    @billing.bill_last_name = params[:billing][:bill_last_name]
    @billing.expiry_month = params[:billing][:expiry_month]
    @billing.expiry_year = params[:billing][:expiry_year]
    @billing.cvc = params[:billing][:cvc]
    @billing.pan = params[:billing][:pan].gsub(/[^0-9]/, "")
    @billing.terms = params[:billing][:terms]
    if @billing.pan > ""  # Only update the last_four DB value from pan attribute accessor if something exists for pan
      @billing.last_four = @billing.pan.to_s.slice(-4..-1)
    end
=end

# OLD CONTENT FROM UPDATE
=begin
@billing.subscription_name = params[:billing][:subscription_name]
@billing.ship_name = params[:billing][:ship_name]
@billing.ship_street = params[:billing][:ship_street]
@billing.ship_city = params[:billing][:ship_city]
@billing.ship_state_province = params[:billing][:ship_state_province]
@billing.ship_postal_code = params[:billing][:ship_postal_code]
@billing.ship_country = params[:billing][:ship_country]
@billing.bill_street = params[:billing][:bill_street]
@billing.bill_city = params[:billing][:bill_city]
@billing.bill_state_province = params[:billing][:bill_state_province]
@billing.bill_postal_code = params[:billing][:bill_postal_code]
@billing.bill_country = params[:billing][:bill_country]
@billing.bill_first_name = params[:billing][:bill_first_name]
@billing.bill_middle_name = params[:billing][:bill_middle_name]
@billing.bill_last_name = params[:billing][:bill_last_name]
@billing.expiry_month = params[:billing][:expiry_month]
@billing.expiry_year = params[:billing][:expiry_year]
@billing.cvc = params[:billing][:cvc]
@billing.pan = params[:billing][:pan].gsub(/[^0-9]/, "")
@billing.terms = params[:billing][:terms]
if @billing.pan > ""  # Only update the last_four DB value from pan attribute accessor if something exists for pan
  @billing.last_four = @billing.pan.to_s.slice(-4..-1)
end
=end

#OLD CONTENT FROM CREATE GATEWAY INTEGREATOIN
=begin
#    email = User.find(@billing.user_id).email
#    billing_address = { :first_name => @billing.bill_first_name, :last_name => @billing.bill_last_name,
#       :address1 => @billing.bill_street, :city => @billing.bill_city, :state => @billing.bill_state_province,
#       :country => @billing.bill_country, :zip => @billing.bill_postal_code }
    shipping_address = { :first_name => @billing.ship_first_name, :last_name => @billing.ship_last_name,:address1 => @billing.ship_street, :city => @billing.ship_city,
      :state => @billing.ship_street, :country => @billing.ship_country, :zip => @billing.ship_postal_code }
    payment_info = {:number => @billing.pan, :verification_value => @billing.cvc, :month => @billing.expiry_month.slice(0..1),
                    :year => @billing.expiry_year, :first_name => @billing.bill_first_name, :last_name => @billing.bill_last_name,
                    :brand => 'visa'}
=end

#OLD CONTENT FROM new_payment_account
=begin
#number = '4222222222222' #Authorize.net test card, error-producing
number = '4007000000027' #Authorize.net test card, non-error-producing

  creditcard = ActiveMerchant::Billing::CreditCard.new(
   :number => number,
   :verification_value => '123',
   :month => 3,        #for test cards, use any date in the future
   :year => 2013,
   :first_name => billing_address[:first_name],
   :last_name => billing_address[:last_name],
   :brand => 'visa'       #note that MasterCard is 'master'
  )
=end

=begin  OLD WAY, WAS WORKING
  def create
    @billing = Billing.new
    @billing.user_id = current_user.id
    set_values(params[:billing])
    profile = Profile.find_by_user_id(current_user.id)
    @billing.subscription_number = profile.subscriptions_created + 1
    if @billing.save
      profile.subscriptions_created += 1
      if profile.save
          flash[:notice] = "Gumgratulations! Your Active Subscription count is now: #{profile.subscriptions_created-profile.subscriptions_deleted}"
          new_payment_account(@ip, @customer, @email, @shipping_address, @billing_address, @payment_info)
        end
      else    #  DUDE, THIS SHOULD NEVER HAPPEN, DOUBLE CHECK AND WRITE APPROPRIATE HANDLING ETC
        flash[:alert] = "Error, with #{profile.subscription_count} Subscriptions counted!"  
      end
      redirect_to(list_billings_url)
    else
      flash[:alert] = "Unable to Update Private Info"
      @content_top = DynamicText.content("billing_top")
      @content_bottom = DynamicText.content("billing_bottom")
      render('new')
    end
  end
=end