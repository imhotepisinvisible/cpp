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

  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  get "emails/:id/preview" => "emails#preview"

  resources :users do
    put 'change_password', :on => :collection, :action => :change_password
  end

  resources :sessions

  resources :companies
  resources :events
  resources :placements
  resources :company_contacts
  resources :departments

  resources :students do
    get 'suggested_degrees', :on => :collection, :action => :suggested_degrees
    delete '/documents/:document_type', :on => :member, :action => :delete_document
    get '/documents/:document_type', :on => :member, :action => :download_document
  end

  resources :tagged_emails

  resources :students do
    resources :events
    resources :placements
  end

  resources :companies do
    resources :events
    resources :placements
    resources :tagged_emails
    resources :company_contacts
    delete '/documents/:document_type', :on => :member, :action => :delete_document
    get '/documents/:document_type', :on => :member, :action => :download_document
    post '/set_rating', :on => :member, :action => :set_rating
  end

  # Samples/Mockups
  match 'student_dash' => 'site#sample_student_dashboard'
  match 'student_companies' => 'site#sample_student_companies'
  match 'student_company' => 'site#sample_student_company'

  match 'company_dash' => 'site#sample_company_dashboard'
  match 'company_students' => 'site#sample_company_students'
  match 'company_student' => 'site#sample_company_student'

  match 'admin_students' => 'site#sample_admin_students'
  match 'admin_companies' => 'site#sample_admin_companies'
  match 'admin_placements' => 'site#sample_admin_placements'
  match 'admin_emails' => 'site#sample_admin_emails'
  match 'admin_stats' => 'site#sample_admin_stats'
  match 'admin_events' => 'site#sample_admin_events'

  match 'tags/skills' => 'tags#skills'
  match 'tags/interests' => 'tags#interests'
  match 'tags/year_groups' => 'tags#year_groups'
  match 'tags/validate' => 'tags#validate'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
