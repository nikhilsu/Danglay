Rails.application.routes.draw do

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  get 'signup' => 'users#new'
  get 'about' => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  root 'cabpools#show'
  get 'saml/init'
  post 'saml/consume'
  post 'show_cabpools' => 'cabpools#show'
  delete 'logout' => 'sessions#destroy'
  post 'cabpools/join' => 'cabpools#join'
  #If Feature toggle is to be used for a specific action
  # if FEATURES.active?('user_feature')
  #   get 'users/new', to: 'users#new'
  # end
  resources :cabpools
  resources :users
end
