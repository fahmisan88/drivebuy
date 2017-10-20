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
      post '/update_location' => 'customers#update_location'
      post '/customer_orders' => 'orders#list_customer_orders'
      resources :restaurants, only: [:index, :show]
      resources :orders, only: :create do
        member do
          post :approve
          post :decline
          post :ready
          post :on_the_way
          post :arrive
          post :deliver
          post :customer_order
        end
      end
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
