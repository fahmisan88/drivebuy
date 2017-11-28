Rails.application.routes.draw do
  root 'pages#home'
  get '/terms' => 'pages#terms'
  get '/privacy' => 'pages#privacy'
  get '/contact' => 'pages#contact'
  get '/business' => 'pages#business'
  get '/payment_success' => 'orders#payment_success'
  get '/payment_fail' => 'orders#payment_fail'

  devise_for :users,
              path: '',
              path_names: {sign_in: 'login', sign_out: 'logout', edit: 'account', sign_up: 'registration'},
              controllers: { registrations: 'registrations',}

  namespace :admin do
    resources :dashboards, only: :index
    resources :restaurants, except: [:new, :create, :edit] do
      member do
        get :menu
      end
    end
    resources :customers, except: [:new, :create, :edit] do
      member do
        get :orders
      end
    end
    resources :meals, except: [:index, :edit, :new]
  end

  namespace :api do
    namespace :v1 do
      post '/check' => 'sessions#check'
      post '/login' => 'sessions#login'
      delete '/logout' => 'sessions#logout'
      post '/register' => 'registrations#create'
      post '/update_profile' => 'customers#update'
      post '/update_location' => 'customers#update_location'
      post '/customer_orders' => 'orders#list_customer_orders'
      post '/current_order' => 'orders#current_order'
      post '/completed_orders' => 'orders#completed_orders'
      post '/current_status' => 'orders#current_status'
      resources :restaurants, only: [:index, :show] do
        member do
          post :open
          post :close
          post :menu
        end
      end
      resources :orders, only: :create do
        member do
          post :approve
          post :decline
          post :ready
          post :on_the_way
          post :arrive
          post :deliver
          post :customer_order
          post :cancel
          post :is_ready
          post :is_approve
          post :is_paid
          post :pay
        end
      end
      resources :meals, only: :nil do
        member do
          post :enable
          post :disable
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
  resources :revenues, only: :index
  resources :orders, only: :nil do
    member do
      get :return
      post :return
      get :callback
      post :callback
      get :pay
    end
  end

end
