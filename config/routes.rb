Rails.application.routes.draw do

  root to: 'welcome#index'
  #root to: "homes#index"
  
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  resources :homes, only: [:index]
  resources :articles do
    get 'search', on: :collection
  end
  resources :themes
  resources :authors
  resources :article_types
  resources :contexts

  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
