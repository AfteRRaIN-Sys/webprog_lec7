Rails.application.routes.draw do
  resources :posts
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get "/main", to: "users#login_page"
  post "/main", to: "users#login"

  get "/register", to: "users#new"
  get "/feed", to: "users#feed"
  get "/new_post",to: "users#new_post" 
  post "create_user_post", to:"users#create_post"
  get "/profile/:username", to: "users#show_post_by_name"

end
