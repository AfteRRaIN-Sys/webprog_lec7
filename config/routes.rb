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
  get "/profile/:name", to: "users#show_post_by_name"
  get "/profile", to: "users#feed"

  get "/search",to: "users#search_user"
  get "/follow/:user_id", to: "users#follow_by_id"
  get "/unfollow/:user_id", to: "users#unfollow_by_id"

  get "/like/:new_post_id", to: "users#like_post"
  get "/unlike/:like_id", to: "users#unlike_post"

end
