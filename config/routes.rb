Rails.application.routes.draw do
  #root to: "welcome#index"
  #root to: "homes#index"
  root to: "public/articles#index"

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

  resources :homes, only: [:index] do
    get '/set_layout/:layout_name' => "homes#set_layout", as: :set_layout, on: :collection
  end

  resources :articles do
    get   "/tags" => "articles#tags", as: :tags, on: :member
    post  "/tags_update" => "articles#tags_update", as: :tags_update, on: :member
    get "/export_pdf" => "articles#article_pdf", as: :export_pdf, on: :member
    get "/autocomplete_term" => "articles#autocomplete_term", as: :autocomplete_term, on: :collection
    get "/search" => "articles#search", as: :article_search, on: :collection
  end

  resources :comments

  resources :themes do
    get "/theme_chapters/new" => "theme_chapters#new", as: :new_theme_chapter#, on: :member
    get "/add_articles_page" => "themes#add_articles_page", as: :add_articles_page , on: :member
    post "/add_article_in_theme" => "themes#add_article_in_theme", as: :add_article_in_theme, on: :member
    post "/remove_article_from_theme" => "themes#remove_article_from_theme", as: :remove_article_from_theme, on: :member
    get "/search_articles" => "themes#search_articles", as: :search_articles, on: :collection
  end
  resources :authors do
    get "/autocomplete_term" => "authors#autocomplete_term", as: :autocomplete_term, on: :collection
  end
  resources :theme_chapters
  resources :comment_reportings, only: [:index, :destroy, :create]
  post "comment_reportings/:comment_id/mark_as_read" => "comment_reportings#mark_as_read", as: :mark_as_read
  resources :tags
  resources :panchangs, only: [:index, :show] do
    get "/pdf/export" => "panchangs#panchang_pdf", as: :export_pdf, on: :member
  end
  
  resources :stories
  
  namespace :admin do
    resources :dashboards, only: [:index] do
    end
    resources :user_mgmts, only: [:index, :show, :destroy] do
      post "/block_to_user" => "user_mgmts#block_to_user", as: :block_to_user, on: :member
      post "/unblock_to_user" => "user_mgmts#unblock_to_user", as: :unblock_to_user, on: :member
      get "/blocked_users" => "user_mgmts#blocked_users", as: :blocked_users, on: :collection
    end
    resources :article_types
    resources :contexts
    resources :articles, only: [:index, :show, :edit, :update, :destroy] do
      get   "/tags" => "articles#tags", as: :tags, on: :member
      post  "/tags_update" => "articles#tags_update", as: :tags_update, on: :member

      get "/approved" => "articles#approved", as: :approved_articles, on: :collection
      get "/pending" => "articles#pending", as: :pending_articles, on: :collection
      get "/rejected" => "articles#rejected", as: :rejected_articles, on: :collection
      post "/approve" => "articles#approve", as: :approve, on: :member
      post "/reject" => "articles#reject", as: :reject, on: :member
    end
    resources :authors, only: [:index, :show, :edit, :update, :destroy] do
      get "/approved" => "authors#approved", as: :approved_authors, on: :collection
      get "/pending" => "authors#pending", as: :pending_authors, on: :collection
      post "/approve" => "authors#approve", as: :approve, on: :member
      post "/reject" => "authors#reject", as: :reject, on: :member
      post "/merge" => "authors#merge", as: :merge, on: :member
      post "/mark_as_sant" => "authors#mark_as_sant", as: :mark_as_sant, on: :member
      post "/remove_from_sant" => "authors#remove_from_sant", as: :remove_from_sant, on: :member
    end
    resources :reports, only: [:index] do
      get '/articles_report' => "reports#articles_report", as: :articles_report, on: :collection
      get '/authors_report' => "reports#authors_report", as: :authors_report, on: :collection
      get '/contexts_report' => "reports#contexts_report", as: :contexts_report, on: :collection
    end

    resources :tags, only: [:index, :show, :edit, :update, :destroy] do
      post "/reject" => "tags#reject", as: :reject, on: :member
      post "/approve" => "tags#approve", as: :approve, on: :member
      get "/approved" => "tags#approved", as: :approved_tags, on: :collection
      get "/rejected" => "tags#rejected", as: :rejected_tags, on: :collection
      post '/convert_tag_to_context' => "tags#convert_tag_to_context", as: :tag_to_context, on: :member
    end

    resources :suggestions, only: [:index, :show] do
      get "/approve" => "suggestions#approve", as: :approve, on: :member
      get "/reject" => "suggestions#reject", as: :reject, on: :member
      get "/approved" => "suggestions#approved", as: :approved, on: :collection
      get "/rejected" => "suggestions#rejected", as: :rejected, on: :collection
    end

    resources :panchangs do
      # get '/get_tithis' => "panchangs#get_tithis", on: :collection

      post '/populate_panchang' => "panchangs#populate_panchang", on: :member, as: :populate_panchang
      post '/add_purshottam_mas' => "panchangs#add_purshottam_mas", on: :member, as: :add_purshottam_mas
      post '/remove_purshottam_mas' => "panchangs#remove_purshottam_mas", on: :member, as: :remove_purshottam_mas

      resources :panchang_tithis do
        get '/:month_id/get_tithis' => "panchang_tithis#get_tithis", as: :get_tithis, on: :collection
      end
    end

    resources :scriptures
    resources :chapters do 
      get '/get_sections' => "chapters#get_sections", as: :get_sections, on: :collection
      get '/get_section_chapters' => "chapters#get_section_chapters", as: :get_section_chapters, on: :collection
      get '/add_section_chapters' => "chapters#add_section_chapters", as: :add_section_chapters, on: :collection
      get '/remove_section_chapters' => "chapters#remove_section_chapters", as: :remove_section_chapters, on: :collection
      post '/add_chapters_in_section' => "chapters#add_chapters_in_section", as: :add_chapters_in_section, on: :collection
      post '/remove_chapters_from_section' => "chapters#remove_chapters_from_section", as: :remove_chapters_from_section, on: :collection
    end
    resources :scripture_articles do
      get '/get_chapters' => "scripture_articles#get_chapters", as: :get_chapters, on: :collection
      get '/get_index' => "scripture_articles#get_index", as: :get_index, on: :collection
      get '/edit_article_index' => "scripture_articles#edit_article_index", as: :edit_article_index, on: :collection
      post '/update_article_index' => "scripture_articles#update_article_index", as: :update_article_index, on: :collection
      get '/get_chapter_articles' => "scripture_articles#get_chapter_articles", as: :get_chapter_articles, on: :collection
    end

    resources :strota
    resources :strota_articles do 
      get '/get_strota_articles' => 'strota_articles#get_strota_articles', as: :get_strota_articles, on: :member
      get '/get_index' => "strota_articles#get_index", as: :get_index, on: :collection
      get '/edit_article_index' => "strota_articles#edit_article_index", as: :edit_article_index, on: :collection
      post '/update_article_index' => "strota_articles#update_article_index", as: :update_article_index, on: :member
    end
  end

  namespace :public, path: :pb do

    resources :articles, only: [:index, :show] do
      # get "/type/:article_type" => "articles#articles_by_type", as: :articles_by_type, on: :collection
      # get "/contexts/:context_name" => "articles#articles_by_context", as: :articles_by_context, on: :collection
      get "/autocomplete_term" => "articles#autocomplete_term", as: :autocomplete_term, on: :collection
      #get "/search_articles" => "articles#search_articles", as: :search_articles, on: :collection
      get "/search" => "articles#search", as: :search, on: :collection
      #get "/search_article/:id" => "articles#search_article", as: :search_article, on: :collection
      #get "/export_pdf" => "articles#article_pdf", as: :export_pdf, on: :member
      get "/article_by_title/:hindi_title" => "articles#article_by_title", as: :article_by_title, on: :collection
      # get "/article_contexts" => "articles#article_contexts", as: :article_contexts, on: :collection
      # get "/article_types" => "articles#article_types", as: :article_types, on: :collection
    end

    resources :user_profiles, only: [:index, :show]

    get "/about" => "abouts#about", as: :about
    resources :suggestions, only: [:index, :new, :create, :show]

    resources :authors, only: [:index, :show] do
      get '/articles_by_author/:author_name' => "authors#articles_by_author", as: :articles_by_author, on: :collection
    end
    resources :tags, only: [:index] do
      get '/:tag_name' => "tags#show", as: :articles_by_tag, on: :collection
    end
    resources :contexts, only: [:index] do
      get '/:context_name' => "contexts#show", as: :articles_by_context, on: :collection
    end
    resources :article_types, only: [:index] do
      get '/:article_type_name' => "article_types#show", as: :articles_by_type, on: :collection
    end
    resources :panchangs, only: [:index, :show]

  end

end
