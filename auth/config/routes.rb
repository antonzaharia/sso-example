Rails.application.routes.draw do
  resources :items
  post 'authenticate', to: 'authentication#authenticate'
  post 'verify-token', to: 'authentication#verify_token'
  root 'authentication#index'
  get 'login', to: 'authentication#login'
  get 'logout', to: 'authentication#logout'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
