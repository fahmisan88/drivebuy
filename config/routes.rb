Rails.application.routes.draw do
  root 'pages#home'
  devise_for :users, controllers: {
    registrations: 'registrations',
  }

  namespace :admin do
    resources :dashboards, only: :index
  end

  namespace :api do
    namespace :v1 do
      post '/login' => 'sessions#login'
      delete '/logout' => 'sessions#logout'
      post '/register' => 'registrations#create'
      post '/update_profile' => 'customers#update'
      resources :restaurants, only: [:index, :show]
    end
  end

  resources :restaurants, only: [:edit, :update]
  resources :meals do
    member do
      post :enable
      post :disable
    end
  end

end
