Rails.application.routes.draw do
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get "/main", to: "users#login_page"
  post "/main", to: "users#login"

end
