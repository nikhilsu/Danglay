Rails.application.routes.draw do

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  get 'signup' => 'users#new'
  get 'about' => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'terms_and_conditions' => 'static_pages#terms_and_conditions'
  get 'privacy_policy' => 'static_pages#privacy_policy'
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
  get 'user_show' => 'users#show'
  get 'admin' => 'admin/cabpools#show'
  get 'admin_user_new' => "admin/users#new"
  post 'admin_user_create' => "admin/users#create"
  post 'view_notification' => 'cabpools#view_notification'
  get 'admin_cabpool_new' => 'admin/cabpools#new'
  post 'admin_cabpool_create' => 'admin/cabpools#create'
  get 'admin_cabpool/:id/edit' =>  'admin/cabpools#edit'
  patch 'admin_cabpool_update' =>  'admin/cabpools#update'
  delete '/admin/cabpools/delete' => 'admin/cabpools#delete'
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
