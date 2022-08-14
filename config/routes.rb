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

  resources :user_profiles do
    get "/comments" => "user_profiles#comments", as: :user_comments, on: :member
    get "/contexts" => "user_profiles#contexts", as: :user_contexts, on: :member
    get "/authors" => "user_profiles#authors", as: :user_authors, on: :member
    get "/articles" => "user_profiles#articles", as: :user_articles, on: :member
  end

  resources :homes, only: [:index]
  resources :articles do 
    get   "/tags" => "articles#tags", as: :tags, on: :member
    post  "/tags_update" => "articles#tags_update", as: :tags_update, on: :member
  end
  resources :comments

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
  resources :comment_reportings, only: [:index, :destroy, :create]
  post "comment_reportings/:comment_id/mark_as_read" => "comment_reportings#mark_as_read", as: :mark_as_read
  resources :tags

  namespace :admin do
    resources :dashboards, only: [:index] do
    end
    resources :user_mgmts, only: [:index, :show, :destroy] do
      post "/block_to_user" => "user_mgmts#block_to_user", as: :block_to_user, on: :member
      post "/unblock_to_user" => "user_mgmts#unblock_to_user", as: :unblock_to_user, on: :member
      get "/blocked_users" => "user_mgmts#blocked_users", as: :blocked_users, on: :collection
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

    resources :tags, only: [:index] do
      post "/reject" => "tags#reject", as: :reject, on: :member
      post "/approve" => "tags#approve", as: :approve, on: :member
      get "/approved" => "tags#approved", as: :approved_tags, on: :collection
      get "/rejected" => "tags#rejected", as: :rejected_tags, on: :collection
    end

    resources :suggestions, only: [:index, :show] do
      get "/approve" => "suggestions#approve", as: :approve, on: :member
      get "/reject" => "suggestions#reject", as: :reject, on: :member
      get "/approved" => "suggestions#approved", as: :approved, on: :collection
      get "/rejected" => "suggestions#rejected", as: :rejected, on: :collection
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

      get "/article_contexts" => "articles#article_contexts", as: :article_contexts, on: :collection
      get "/article_types" => "articles#article_types", as: :article_types, on: :collection
    end
    resources :user_profiles, only: [:index, :show] do
    end
    get "/about" => "abouts#about", as: :about
    resources :suggestions, only: [:index, :new, :create, :show]

    resources :tags, only: [:index] do
      get '/:tag_name' => "tags#show", as: :tag_articles, on: :member
    end

    resources :contexts, only: [:index] do 
      get '/:context_name' => "contexts#show", as: :context_articles, on: :member
    end

    resources :article_types, only: [:index] do 
      get '/:article_type_name' => "article_types#show", as: :article_by_types, on: :member
    end
  end

end
