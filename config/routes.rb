# encoding: utf-8
Petshop3::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
  
  resources :colours, :contacts, :photos, :sizes, :items, :cart_items, :users, :orders, :closed_orders
  resource :cart

  resource :session do
    member do
      get :forgot_password
    end
  end

  resources :processed_orders do
    member do
      get :close
    end
  end

  resources :forum_posts do
    member do
      get :reply
    end
  end

  match '/signup' => 'users#new', :as => :signup
  match '/login' => 'sessions#new', :as => :login
  match '/logout' => 'sessions#destroy', :as => :logout
  
  resources :categories do
    resources :catalog_items, :summer_catalog_items, :winter_catalog_items
  end


  resources :catalog_items, :summer_catalog_items, :winter_catalog_items do
    collection do
      get :search
    end
  end

#    resources :summer_catalog_items do
#      collection do
#        get :search
#      end
#    end

#    resources :winter_catalog_items do
#      collection do
#        get :search
#      end
#    end


#    scope :controller => :catalog_items do
#      match 'catalog_items' => :index
#      match 'summer_catalog_items' => :index
#      match 'winter_catalog_items' => :index
#    end

  match '/' => 'catalog_items#index'
  match '/:controller(/:action(/:id))'  
  
end
