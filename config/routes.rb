Rails.application.routes.draw do

  root to: 'welcome#index'
  #root to: "homes#index"
  
  get '/autocomplete_term', to: "welcome#autocomplete_term"
  get '/search_term', to: "welcome#search_term"
  get '/search_article/:id', to: "welcome#search_article"

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations'
  }

  resources :user_profiles

  resources :homes, only: [:index]
  resources :articles
  resources :themes
  resources :authors
  resources :article_types
  resources :contexts

  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
