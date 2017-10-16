Rails.application.routes.draw do
  root 'pages#home'
  devise_for :users

  namespace :admin do
    resources :dashboards, only: :index
  end

  namespace :api do
    namespace :v1 do
      post '/login' => 'sessions#login'
      delete '/logout' => 'sessions#logout'

      resources :restaurants
    end
  end

end
