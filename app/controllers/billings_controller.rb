class BillingsController < ApplicationController

#  turning this on for all pages, adding at application layer  
#  force_ssl
    
  require 'active_merchant'
#  ActiveMerchant::Billing::Base.mode = :development  #  <--  UPDATE THIS FOR PRODUCTION
 ActiveMerchant::Billing::Base.mode = :production
  
  before_filter :authenticate_user!

#######################################################################    
  LOGIN_ID = '5Eh4LJew5B'
  TRANSACTION_KEY = '54tdwP67b7GLps6L'
#######################################################################  

  def index
    list
    render('list')
  end
  
  def list
   @subscription_list = Kaminari.paginate_array(Billing.find_all_by_user_id(current_user.id, :order => 'created_at ASC')).page(params[:page])
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
    # payment info not set in "set_values" because only used for new subscriptions
    @payment_info = {:number => @billing.pan, :verification_value => @billing.cvc, :month => @billing.expiry_month.slice(0..1).to_i,
        :year => @billing.expiry_year, :first_name => @billing.bill_first_name, :last_name => @billing.bill_last_name}#,:brand => 'visa'} #BRAND IS STILL STATIC...
    profile = Profile.find_by_user_id(current_user.id)
    @billing.subscription_number = profile.subscriptions_created + 1
    creditcard = ActiveMerchant::Billing::CreditCard.new(@payment_info)
    if creditcard.valid?
      if @billing.valid?
        creditcard = ActiveMerchant::Billing::CreditCard.new(@payment_info)
        gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(:login => LOGIN_ID, :password => TRANSACTION_KEY)
        options = {:interval => { :unit => :months, :length => '1' }, :duration => { :start_date => get_start_date, :occurrences => 9999},
                  :shipping_address => @shipping_address, :billing_address => @billing_address, :customer => @customer, :order => @order,
                  :ip => @ip}
        response = gateway.recurring(800, creditcard, options)        
        if response.success?
          @billing.gateway_subscriber_id = response.params["subscription_id"]
          @billing.save
          profile.subscriptions_created += 1
          profile.save
          UserMailer.new_billing_email(@billing).deliver         
          # this was the temp dislayed return message from gateway
          # flash[:alert] = "Success: " + response.message.to_s
          flash[:notice] = "Gumgratulations, new Subscription Created! Your Active Subscription count is now: #{profile.subscriptions_created-profile.subscriptions_deleted}"
          redirect_to(list_billings_url)
        else
          flash[:alert] = "Unable to Create Subscription: " + response.message.to_s
          @content_top = DynamicText.content("billing_top")
          @content_bottom = DynamicText.content("billing_bottom")
          render('new')  
        end
      else # @billing not valid
        flash[:alert] = "Unable to Create New Subscription"
        @content_top = DynamicText.content("billing_top")
        @content_bottom = DynamicText.content("billing_bottom")
        render('new')
      end
    else # creditcard not valid
      flash[:alert] = "Credit Card not valid: #{creditcard.errors.full_messages.join('. ')}"
      @content_top = DynamicText.content("billing_top")
      @content_bottom = DynamicText.content("billing_bottom")
      render('new')    
    end
  end
  
  def update
    @billing = Billing.find_by_user_id_and_subscription_number(current_user.id, params[:id])
    set_values(params[:billing]) #payment card info not updated
    if @billing.save
      gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(:login => LOGIN_ID, :password => TRANSACTION_KEY)
      options = {:subscription_id => @billing.gateway_subscriber_id,
                 :shipping_address => @shipping_address, :billing_address => @billing_address, :customer => @customer, :order => @order }
      response = gateway.update_recurring(options)      
      if response.success?    
        UserMailer.updated_billing_email(@billing).deliver
        flash[:notice] = "Gumgratulations, your subscription was updated successfully!"
        redirect_to(list_billings_url)
      else
        flash[:alert] = "Unable to Update Subscription: " + response.message.to_s
        redirect_to(list_billings_url)
      end
    else # @billing.save failed
      flash[:alert] = "Unable to Update Subscription"
      @content_top = DynamicText.content("billing_top")
      @content_bottom = DynamicText.content("billing_bottom")
      render('edit')
    end
  end  

  def delete_confirmation
    @billing = Billing.find_by_user_id_and_subscription_number(current_user.id, params[:subscription_number])
    @content = DynamicText.content("billing_delete")
  end
  
  def destroy
    billing = Billing.find_by_user_id_and_subscription_number(current_user.id, params[:subscription_number])
    profile = Profile.find_by_user_id(current_user.id)
    if billing.destroy
      profile.subscriptions_deleted += 1      
      profile.save
      gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(:login => LOGIN_ID, :password => TRANSACTION_KEY)
      response = gateway.cancel_recurring(billing.gateway_subscriber_id)      
      if response.success?
        UserMailer.deleted_billing_email(billing).deliver
        flash[:notice] = "Sorry to see you cancel your subscription :-("  
        log = DeletedObject.new
        log.deleted_type = "Billing Subscription"
        log.reason = params[:billing][:reason]
        log.user_id = current_user.id
        log.user_email = current_user.email
        log.billing_gateway_subscriber_id = billing.gateway_subscriber_id
        log.profile_id = profile.id
        log.billing_subscription_id = profile.subscriptions_created-profile.subscriptions_deleted-1 # minus one because already added 1 to deleted just a sec ago lol
        log.billing_last_four = billing.last_four
        log.billing_bill_name = billing.bill_first_name+" "+billing.bill_last_name+" (company: "+billing.bill_company+")"
        log.billing_ship_name = billing.ship_first_name+" "+billing.ship_last_name+" (company: "+billing.ship_company+")"
        log.deleted_object_creation_dt = billing.created_at
        log.save
        redirect_to(list_billings_url)
      else
        flash[:alert] = "Unable to Cancel Subscription: " + response.message.to_s
        redirect_to(list_billings_url)
      end
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
    @billing.ship_company = billing_info[:ship_company]
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
    @billing.bill_company = billing_info[:bill_company]
    @billing.cvc = billing_info[:cvc]
    @billing.terms = billing_info[:terms]
    unless billing_info[:pan].blank? # Only update the last_four DB value from pan attribute accessor if something exists for pan
      @billing.pan = billing_info[:pan].gsub(/[^0-9]/, "")
      @billing.last_four = @billing.pan.to_s.slice(-4..-1)
      @billing.expiry_month = billing_info[:expiry_month]
      @billing.expiry_year = billing_info[:expiry_year]
    end
    @ip = User.find(@billing.user_id).current_sign_in_ip
#    @customer = {:id => @billing.user_id.to_s+"-"+(Profile.find_by_user_id(@billing.user_id).subscriptions_created+1).to_s, :email => User.find(@billing.user_id).email}      
    @customer = {:id => @billing.user_id.to_s, :email => User.find(@billing.user_id).email}      
    @order = { :invoice_number => '', :description => @billing.subscription_name }
    @shipping_address = { :first_name => @billing.ship_first_name, :last_name => @billing.ship_last_name, :company => @billing.ship_company,
         :address1 => @billing.ship_street, :city => @billing.ship_city, :state => @billing.ship_state_province, :country => @billing.ship_country, :zip => @billing.ship_postal_code }
    @billing_address = { :first_name => @billing.bill_first_name, :last_name => @billing.bill_last_name, :company => @billing.bill_company,
        :address1 => @billing.bill_street, :city => @billing.bill_city, :state => @billing.bill_state_province,
        :country => @billing.bill_country, :zip => @billing.bill_postal_code }
  end

  def get_start_date      
    if DateTime.now.day >= 8                                # ... too late for the current month's subscription
      if DateTime.now.month == 12                           # ... if it's December, subscription starts next "year"
        Date.new(DateTime.now.year+1,DateTime.now.month+1,8).strftime("%Y-%m-%d")
      else                                                # ... if it's NOT December, subscription starts current "year"
        Date.new(DateTime.now.year,DateTime.now.month+1,8).strftime("%Y-%m-%d")
      end
    else                                                  # ... still early enough for current month's subscription
      Date.new(DateTime.now.year,DateTime.now.month,8).strftime("%Y-%m-%d")
    end
  end

end