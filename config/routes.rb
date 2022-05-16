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
  resources :themes do
    get '/theme_chapters/new' => 'theme_chapters#new', as: :new_theme_chapter#, on: :member 
    get '/add_articles_page' => "themes#add_articles_page", as: :add_articles_page , on: :member 
    post '/add_article_in_theme' => 'themes#add_article_in_theme', as: :add_article_in_theme, on: :member 
    get '/search_articles' => "themes#search_articles", as: :search_article, on: :collection
    get '/search_term' => "themes#search_term", as: :search_term, on: :collection
  end
  resources :authors
  resources :article_types
  resources :contexts
  resources :theme_chapters

  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
