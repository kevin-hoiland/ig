IntlGum2::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  root :to => 'welcomes#index'

  devise_for :users
  
  get 'users' => 'profiles#index'

  get 'members' => 'profiles#index', :as => "profiles"
  get 'member_edit_self' => 'profiles#edit', :as => "edit_profile"
  get 'members/:id' => 'profiles#show', :as => "profile"
  put 'members/:id' => 'profiles#update', :as => "profile"
  get 'member_edit_self_private' => 'profiles#edit_private', :as => "edit_private_profile"
  put 'member_edit_self_private' => 'profiles#update_billing', :as => "billing"

  get "/welcomes/about"
  get "/welcomes/contact_info"
  get "/welcomes/faq"
  get "/welcomes/news"
  get "/welcomes/corporate_info"
  get "/welcomes/shipping_policy"
  get "/welcomes/returns_and_refunds"
  get "/welcomes/privacy_and_security"
  get "/welcomes/partners"
    
  resources :gums, :only => [:index, :show]   
  post "gum/:permalink/vote_up" => "gums#vote_up", :as => "vote_gum_up"
  get "gum/:permalink/vote_up" => "gums#vote_up", :as => "vote_gum_up" # used for session expiration and attempting to up/down
  post "gum/:permalink/vote_down" => "gums#vote_down", :as => "vote_gum_down"
  get "gum/:permalink/vote_down" => "gums#vote_down", :as => "vote_gum_down"# used for session expiration and attempting to up/down

  # no show dude, show for ratings is either gum show or profile show
  get 'ratings' => 'ratings#index' # get to view all ratings
  get "new_rating/gum/:gum_permalink" => "ratings#new", :as => "new_rating" # for new (get)
  post "new_rating/gum/:gum_permalink" => "ratings#create", :as => "gum_rating_relationships" # for create (post)
  get 'ratings/:id/edit' => 'ratings#edit', :as => "edit_rating" # edit rating view
  put 'ratings/:id' => 'ratings#update', :as => "gum_rating_relationship" # update an existing rating
#  delete 'ratings/:id' => 'ratings#destroy' # destroy an existing rating  <--  NOT SHIPPING WITH THIS FEATURE (at least for Users)
  get 'ratings/:id' => 'ratings#show', :as => "rating"
  get 'ratings/gum/:gum_permalink' => "ratings#per_gum", :as => "gum_ratings"
  get 'ratings/member/:id' => "ratings#per_member", :as => "member_ratings"

  get 'subscriptions' => 'subscriptions#index'  
  get 'your_private_subscriptions' => 'billings#index', :as => 'list_billings'
  get 'new_private_subscription' => 'billings#new', :as => 'new_billing'
  post 'new_private_subscription' => 'billings#create', :as => 'new_billing'
  get 'edit_private_subscription/:id' => 'billings#edit', :as => 'edit_billing'
  put 'edit_private_subscription/:id' => 'billings#update', :as => 'edit_billing'
  get 'remove_private_subscription/:subscription_number' => 'billings#delete_confirmation', :as => 'delete_billing'
  delete 'remove_private_subscription/:subscription_number' => 'billings#destroy', :as => 'delete_billing'
  
  # The priority is based upon order of creation:
  # first created -> highest priority.
  
  # root :to => "home#index"
  
  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
  
end
