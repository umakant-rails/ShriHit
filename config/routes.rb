Rails.application.routes.draw do

  #root to: "welcome#index"
  #root to: "homes#index"
  root to: "public/articles#index"

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
    resources :articles, only: [:index, :update] do
      get "/approved" => "articles#approved", as: :approved_articles, on: :collection
      get "/pending" => "articles#pending", as: :pending_articles, on: :collection
      get "/report" => "articles#report", as: :report_articles, on: :collection
      get "/approve" => "articles#approve", as: :approve, on: :member
      get "/reject" => "articles#reject", as: :reject, on: :member
      post "/merge" => "articles#merge", as: :merge, on: :member
    end
    resources :authors, only: [:index, :update] do
      get "/approved" => "authors#approved", as: :approved_authors, on: :collection
      get "/pending" => "authors#pending", as: :pending_authors, on: :collection
      get "/report" => "authors#report", as: :report_authors, on: :collection
      get "/approve" => "authors#approve", as: :approve, on: :member
      get "/reject" => "authors#reject", as: :reject, on: :member
      post "/merge" => "authors#merge", as: :merge, on: :member
    end
    resources :contexts, only: [:index, :update] do
      get "/approved" => "contexts#approved", as: :approved_contexts, on: :collection
      get "/pending" => "contexts#pending", as: :pending_contexts, on: :collection
      get "/report" => "contexts#report", as: :report_contexts, on: :collection
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
      get "/autocomplete_term" => "articles#autocomplete_term", as: :autocomplete_term, on: :collection
      get "/search_term" => "articles#search_term", as: :search_term, on: :collection
      #get "/search_article/:id" => "articles#search_article", as: :search_article, on: :collection
      get "/export_pdf" => "articles#article_pdf", as: :export_pdf, on: :member
    end
    resources :user_profiles, only: [:index, :show] do
    end
    get "/about" => "abouts#about", as: :about
    resources :suggestions, only: [:index, :new, :create, :show]
    #get "/suggestions/new" => "suggestions#new", as: :suggestions
  end

  namespace :public_page do
    resources :export, only: [:index] do
      get "/export_pdf" => "export#article_pdf", as: :export_pdf, on: :member
    end
  end

end
