# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
IntlGum2::Application.initialize!

# Action Mailer configuration for Gmail
# config.action_mailer.delivery_method = :smtp
# config.action_mailer.smtp_settings = {
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address => 'smtp.gmail.com',
  :port => 587,
  :domain => 'mail.intlgum.com',
  :user_name => 'notifications@intlgum.com',
  :password => 'n0t1fy@ll',
  :authentication => 'plain',
  :enable_starttls_auto => true  }