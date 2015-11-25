Rails.application.routes.draw do

  # get 'signup' => 'users#new'
  root 'static_pages#home'
  resources :users
end
