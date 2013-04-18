# Create default admin user
  AdminUser.create!([:email => 'admin@example.com', :password => 'password', :password_confirmation => 'password'], :without_protection => true)

# Create default dynamic text
File.open("db/initial_text3.txt", "r") do |defaults|
  defaults.read.each_line do |text|
    location, sequence, size, visible, content = text.chomp.split("|")
    DynamicText.create!([:location => location, :sequence => sequence, :size => size, :visible => visible, :content => content], :without_protection => true)
  end
end

# Create default set of gums
File.open("db/initial_gums6_mini.txt", "r") do |gums|
  gums.read.each_line do |gum|
    permalink, title, upc, active, discontinued, company, brand, flavor, description, note, country, new_release, image = gum.chomp.split("|")
    # Gum.create!(:permalink => permalink, :upc => upc, :active => active, :company => company, :brand => brand, :flavor => flavor, :description => description, :note => note, :country => country, :new_release => new_release)
    # Gum.create!(:permalink => permalink, :upc => upc, :active => active, :company => company, :brand => brand, :flavor => flavor, :description => description, :note => note, :country => country, :new_release => new_release, :image => (File.open(File.join(Rails.root, image))))
     #Gum.create!(:permalink => permalink, :upc => upc, :active => active, :company => company, :brand => brand, :flavor => flavor, :description => description, :note => note, :country => country, :new_release => new_release, :image => image )


# works but is super slow
#     Gum.create!(:permalink => permalink, :upc => upc, :active => active, :company => company, :brand => brand, :flavor => flavor, :description => description, :note => note, :country => country, :new_release => new_release, :image => File.open(File.join(Rails.root, '/lib/assets/'+image)))

     Gum.create!([:permalink => permalink, :title => title, :upc => upc, :active => active, :discontinued => discontinued, :company => company, :brand => brand, :flavor => flavor, :description => description, :note => note, :country => country, :new_release => new_release, :image => File.open(File.join(Rails.root, '/lib/assets/images/gums/'+image))], :without_protection => true)

#    g = Gum.create!(:permalink => permalink, :upc => upc, :active => active, :company => company, :brand => brand, :flavor => flavor, :description => description, :note => note, :country => country, :new_release => new_release)
#        g.image.store!(File.open(File.join(Rails.root+"/lib/assets", image)))
#        g.save!

#    g.raw_write_attribute(:image, image)
#    g.save!

#    g = Gum.create!(:permalink => permalink, :upc => upc, :active => active, :company => company, :brand => brand, :flavor => flavor, :description => description, :note => note, :country => country, :new_release => new_release)
#    g.image.store!(File.open(File.join(Rails.root/../gum_images_local, image)))
#    g.save!
#    g = Gum.create!(:permalink => permalink, :upc => upc, :active => active, :company => company, :brand => brand, :flavor => flavor, :description => description, :note => note, :country => country, :new_release => new_release)
#    g.image.store!(File.open(File.join(Rails.root, image)))
#    gum.image << g
#    gum.save!
  end
end

# Create default set of gums