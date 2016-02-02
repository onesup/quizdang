Rails.application.routes.draw do
  # devise
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  #high_voltage
  get '/pages/*id' => 'pages#show', as: :page, format: false

  root to: 'intros#index'
  get 'search', to: 'search#index'
  post 'search', to: 'search#index'

  # service
  resources :users, only: [:show, :edit, :update]
  resources :quizzes, only: [:show]
  resources :questions, shallow: true do
    get 'guide', on: :collection
    get 'random', on: :collection
    get 'embed', on: :member
    post 'vote', on: :member
    post 'favorite', on: :member
    resources :participants, only: [:show, :create]
    resources :answers do
      post 'vote', on: :member
    end
    resources :comments do
      post 'vote', on: :member
    end
  end

  resources :subdangs, only: [:index, :show], path: 's'
  resources :users, only: [:index, :show]
  resources :badges, only: [:index, :show]
  resources :hashtags, only: [:index, :show, :new, :create]
  resources :photos, only: [:index] do
    post 'vote', on: :member
  end
  resources :tickets, only: [:new, :create]

  # admin
  namespace :admin, constraints: AdminConstraints.new do
    root to: 'dashboards#index'

    resources :dashboards, only: [:index]
    resources :quizzes, shallow: true do
      resources :questions
    end
    resources :questions, only: [:index]
    resources :options
    resources :participants
    resources :users, only: [:index, :show]
    resources :photos, only: [:index]
    resources :subdangs, only: [:index, :show]
    resources :badges
    resources :tickets
  end
end
