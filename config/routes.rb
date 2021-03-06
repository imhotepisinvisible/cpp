CPP::Application.routes.draw do

  devise_for :users, :skip => :registrations
  devise_for :students, :skip => [:sessions, :registrations]
  devise_for :department_administrators, :skip => [:sessions, :registrations]
  devise_for :company_administrators, :skip => [:sessions, :registrations]
  devise_for :readonly_administrators, :skip => [:sessions, :registrations]

  as :user do
    put 'users' => 'devise/registrations#update', :as => :user_registration
    delete '/logout', :to => 'devise/sessions#destroy', :as => :destroy_user_session
    get '/login', :to => 'devise/sessions#new', :as => :new_user_session
    post '/login', :to => 'devise/sessions#create', :as => :user_session
  end

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

  # Non-Backbone Routes
  get ":controller/:id/stat_show", :action => "stat_show"

  get "events/:id/approve" => "events#email_approve"
  get "events/:id/reject" => "events#email_reject"

  get "opportunities/:id/approve" => "placements#email_approve"
  get "opportunities/:id/reject" => "placements#email_reject"

  get "emails/:id/preview" => "emails#preview"

  get "events/:event_id/departments/approved" => "departments#approved"
  get "companies/view_stats_all" => "companies#view_stats_all"
  get "students/top_5" => "students#top_5"
  get "companies/top_5" => "companies#top_5"
  get "events/top_5" => "events#top_5"
  get "placements/top_5" => "placements#top_5"

  get 'students/:id/documents/:document_type' => 'students#download_document'
  get 'export_cvs' => 'students#export_cvs'

  get 'students/:id/request_approval' => 'students#request_approval'

  require 'resque_scheduler/server'
  #namespace :admin do
  constraints CanAccessResque do
    mount Resque::Server, :at => "/resque"
  end
  #end

  # Pass all other routes through to Backbone
  class XHRConstraint
    def matches?(request)
      !request.xhr? && !(request.url =~ /\.csv$/) && !(request.url =~ /\.json$/ && ::Rails.env == 'development')
    end
  end
  match '(*url)' => 'site#index', :constraints => XHRConstraint.new

  resources :audit_items
  resources :companies
  resources :courses
  resources :events do
    post '/register', :on => :member, :action => :register
    post '/unregister', :on => :member, :action => :unregister
    get :pending, :on => :collection
    #get :approve, :on => :member
    put :approve, :on => :member
    put :reject, :on => :member
    get :attending_students, :on => :member
  end
  resources :placements do
    get :pending, :on => :collection
    put :approve, :on => :member
    put :reject, :on => :member
  end
  resources :departments
  resources :department_administrators
  resources :readonly_administrators
  resources :departments do
    resources :department_administrators
    resources :readonly_administrators
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
    get 'view_stats_all', :on => :collection, :action => :view_stats_all
    get 'suggested_degrees', :on => :collection, :action => :suggested_degrees
    delete '/documents/:document_type', :on => :member, :action => :delete_document
    get '/documents/:document_type', :on => :member, :action => :download_document
    put 'suspend', :on => :collection, :action => :suspend
  end

  resources :tagged_emails
  resources :event_emails
  resources :direct_emails

  resources :emails do
    get :pending, :on => :collection
    put :approve, :on => :member
    put :reject, :on => :member
  end

  get "emails/:id/get_matching_students_count" => "emails#get_matching_students_count"

  resources :students do
    resources :events
    resources :placements
  end

  resources :companies do
    resources :events
    resources :placements
    resources :emails
    resources :tagged_emails
    resources :event_emails
    resources :direct_emails
    resources :departments
    resources :departments do
      put 'status', :action => :set_status
      get 'status', :action => :get_status
      put :apply
    end
    resources :company_contacts do
      post :sort, :on => :collection
      get :position_clean, :on => :collection
    end
    delete '/logo', :on => :member, :action => :delete_logo
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
