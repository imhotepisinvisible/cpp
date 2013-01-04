CPP::Application.routes.draw do

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
  root :to => 'site#index'

  get ":controller/:id/stat_show", :action => "stat_show"

  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  get "tagged_emails/:id/preview" => "tagged_emails#preview"

  resources :users do
    put 'change_password', :on => :collection, :action => :change_password
    put 'forgot_password', :on => :collection, :action => :forgot_password
  end

  resources :sessions

  resources :companies
  resources :events do
    post '/register', :on => :member, :action => :register
    post '/unregister', :on => :member, :action => :unregister
  end
  resources :placements
  resources :departments
  resources :departments do
    resources :companies do
      get :pending, :on => :collection
      put :approve, :on => :member
      put :reject, :on => :member
    end
  end
  resources :company_administrators
  resources :company_contacts do
    post :sort, :on => :collection
  end
  resources :students do
    get 'suggested_degrees', :on => :collection, :action => :suggested_degrees
    delete '/documents/:document_type', :on => :member, :action => :delete_document
    get '/documents/:document_type', :on => :member, :action => :download_document
  end

  resources :tagged_emails
  resources :event_emails

  get "tagged_emails/:id/get_matching_students_count" => "tagged_emails#get_matching_students_count"

  resources :students do
    resources :events
    resources :placements
  end

  resources :companies do
    resources :events
    resources :placements
    resources :tagged_emails
    resources :event_emails
    resources :departments
    resources :departments do
      put :change_status
      put :apply
    end
    resources :company_contacts do
      post :sort, :on => :collection
      get :position_clean, :on => :collection
    end
    delete '/documents/:document_type', :on => :member, :action => :delete_document
    get '/documents/:document_type', :on => :member, :action => :download_document
    post '/set_rating', :on => :member, :action => :set_rating
    get 'view_stats', :on => :member, :action => :view_stats
  end

  match 'tags/skills' => 'tags#skills'
  match 'tags/interests' => 'tags#interests'
  match 'tags/year_groups' => 'tags#year_groups'
  match 'tags/reject_skills' => 'tags#reject_skills'
  match 'tags/reject_interests' => 'tags#reject_interests'
  match 'tags/validate' => 'tags#validate'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
