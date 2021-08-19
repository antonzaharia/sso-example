Rails.application.routes.draw do
  root 'homes#index'
  post 'logout', to: 'homes#logout'
end
