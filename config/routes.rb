Rails.application.routes.draw do
  resources :themes
  resources :articles
  

  root to: 'welcome#index'
  #root to: "home#index"
  
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  resources :homes, only: [:index]
  resources :articles
  resources :authors
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
