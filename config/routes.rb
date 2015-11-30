Rails.application.routes.draw do

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  get 'signup' => 'users#new'
  root 'static_pages#home'
  get 'saml/init'
  post 'saml/consume'
  delete 'logout' => 'sessions#destroy'
  #If Feature toggle is to be used for a specific action
  # if FEATURES.active?('user_feature')
  #   get 'users/new', to: 'users#new'
  # end
  resources :cabpools
  resources :users
end
