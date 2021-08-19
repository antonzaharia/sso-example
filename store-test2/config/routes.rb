Rails.application.routes.draw do
  resources :homes
  root 'homes#index'
  post 'logout', to: 'homes#logout'
end
