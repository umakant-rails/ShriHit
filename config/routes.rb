Rails.application.routes.draw do

  root to: "welcome#index"
  #root to: "homes#index"
  
  get "/autocomplete_term", to: "welcome#autocomplete_term"
  get "/search_term", to: "welcome#search_term"
  get "/search_article/:id", to: "welcome#search_article"

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords",
    confirmations: "users/confirmations"
  }

  resources :user_profiles
  resources :homes, only: [:index]
  resources :articles
  resources :themes do
    get "/theme_chapters/new" => "theme_chapters#new", as: :new_theme_chapter#, on: :member
    get "/add_articles_page" => "themes#add_articles_page", as: :add_articles_page , on: :member
    post "/add_article_in_theme" => "themes#add_article_in_theme", as: :add_article_in_theme, on: :member
    post "/remove_article_from_theme" => "themes#remove_article_from_theme", as: :remove_article_from_theme, on: :member
    get "/search_articles" => "themes#search_articles", as: :search_article, on: :collection
  end
  resources :authors
  resources :article_types
  resources :contexts
  resources :theme_chapters

  namespace :admin do
    resources :dashboards, only: [:index] do
    end
    resources :authors, only: [:index, :update] do
      get "/pending_authors" => "authors#pending_authors", as: :pending_authors, on: :collection
      get "/approve" => "authors#approve", as: :approve, on: :member
      get "/reject" => "authors#reject", as: :reject, on: :member
      post "/merge" => "authors#merge", as: :merge, on: :member
    end
    resources :contexts, only: [:index, :update] do
      get "/pending_contexts" => "contexts#pending_contexts", as: :pending_contexts, on: :collection
      get "/approve" => "contexts#approve", as: :approve, on: :member
      get "/reject" => "contexts#reject", as: :reject, on: :member
      post "/merge" => "contexts#merge", as: :merge, on: :member
    end
  end
  
  namespace :public, path: :pb do
    resources :authors, only: [:index, :show]
    resources :articles, only: [:index, :show] do
      get "/type/:article_type" => "articles#articles_by_type", as: :articles_by_type, on: :collection
      get "/contexts/:context_name" => "articles#articles_by_context", as: :articles_by_context, on: :collection
    end
    resources :user_profiles, only: [:index, :show] do
    end
    get "/about" => "abouts#about", as: :about
  end

end
