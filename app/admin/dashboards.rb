ActiveAdmin::Dashboards.build do

  section "Recent Members", :priority => 1 do 
      table_for User.order("created_at desc").limit(5) do  
        column :email do |user|  
          link_to user.email, admin_user_path(user)
        end
        column :profile do |user|  
          if user.profile
            link_to user.profile.id, admin_profile_path(user)
          end
        end
        column :created_at 
      end  
      strong { link_to "View All Users", admin_users_path }
      strong { link_to "View All Profiles", admin_profiles_path } 
  end
  
  section "Recent Gum Ratings", :priority => 2 do 
      table_for GumRatingRelationship.order("created_at desc").limit(5) do  
        column :gum_id do |gum|  
          link_to gum.gum_id, admin_gum_path(gum.gum_id)
        end
        column :average
        column :total
        column :created_at 
      end  
      strong { link_to "View All Gum Ratings", admin_ratings_path }  
  end

  section "Recent Subscriptions", :priority => 3 do 
      table_for Billing.order("created_at desc").limit(5) do  
        column :user_id do |billing|  
          link_to billing.user_id, admin_user_path(billing.user_id)
        end
        column :subscription_name
        column :ship_city
        column :ship_postal_code
      end  
      strong { link_to "View Subscriptions", admin_billings_path }  
  end
  
  
=begin
  section "Current Totals", :priority => 3 do 
    User.count
  end
=end
  
  # Define your dashboard sections here. Each block will be
  # rendered on the dashboard in the context of the view. So just
  # return the content which you would like to display.
  
  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  #   section "Recent Posts" do
  #     ul do
  #       Post.recent(5).collect do |post|
  #         li link_to(post.title, admin_post_path(post))
  #       end
  #     end
  #   end
  
  # == Render Partial Section
  # The block is rendered within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     div do
  #       render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #     end
  #   end
  
  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.
  
  # == Conditionally Display
  # Provide a method name or Proc object to conditionally render a section at run time.
  #
  # section "Membership Summary", :if => :memberships_enabled?
  # section "Membership Summary", :if => Proc.new { current_admin_user.account.memberships.any? }

end
