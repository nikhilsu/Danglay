Rails.application.routes.draw do

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  get 'signup' => 'users#new'
  get 'about' => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  root 'cabpools#show'
  get 'saml/init'
  post 'saml/consume'
  post 'show_cabpools' => 'cabpools#show'
  post 'leave_cabpool' => 'cabpools#leave'
  delete 'logout' => 'sessions#destroy'
  post 'cabpools/join' => 'cabpools#join'
  get 'approve_reject_handler' => 'cabpools#approve_reject_handler'
  post 'approve_via_notification' => 'cabpools#approve_via_notification'
  post 'reject_via_notification' => 'cabpools#reject_via_notification'
  get 'your_cabpools' => 'cabpools#your_cabpools'
  get 'edit' => 'users#edit'
  get 'admin' => 'admin/cabpools#show'
  get 'admin_new' => "admin/users#new"
  post 'admin_create' => "admin/users#create"
  #If Feature toggle is to be used for a specific action
  # if FEATURES.active?('user_feature')
  #   get 'users/new', to: 'users#new'
  # end
  default_url_options :host => "localhost:3000"
  resources :cabpools
  resources :users

  if Rails.env.production? || Rails.env.staging? || Rails.env.test?
    match '404', :to => 'custom_errors#page_not_found', via: [:get, :post]
    match '422', :to => 'custom_errors#server_error', via: [:get, :post]
    match '500', :to => 'custom_errors#server_error', via: [:get, :post]
  end
end
