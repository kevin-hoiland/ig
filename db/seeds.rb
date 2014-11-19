#=begin
# Create default admin user
  AdminUser.create!([:email => 'kevin.hoiland@intlgum.com', :password => '1ntlP@s54kevho', :password_confirmation => '1ntlP@s54kevho'], :without_protection => true)
#=end

#=begin
# Create default dynamic text
File.open("db/initial_text3.txt", "r") do |defaults|
  defaults.read.each_line do |text|
    location, sequence, size, visible, content = text.chomp.split("|")
    DynamicText.create!([:location => location, :sequence => sequence, :size => size, :visible => visible, :content => content], :without_protection => true)
  end
end
#=end

#=begin
# Create default set of gums
File.open("db/initial_gums7.txt", "r") do |gums|
  gums.read.each_line do |gum|
    permalink, title, upc, active, discontinued, company, brand, flavor, description, note, country, new_release, image = gum.chomp.split("|")
    Gum.create!([:permalink => permalink, :title => title, :upc => upc, :active => active, :discontinued => discontinued, :company => company, :brand => brand, :flavor => flavor, :description => description, :note => note, :country => country, :new_release => new_release, :image => File.open(File.join(Rails.root, '/lib/assets/images/gums/'+image))], :without_protection => true)
  end
end
#=end