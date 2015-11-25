Rails.application.routes.draw do

  get 'signup' => 'users#new'
  root 'static_pages#home'

  #If Feature toggle is to be used for a specific action
  # if FEATURES.active?('user_feature')
  #   get 'users/new', to: 'users#new'
  # end

  resource :users
end
