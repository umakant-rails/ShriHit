class SearchController < ApplicationController

  def autocomplete_term
    search_term = params[:q].strip

    if params[:search_in] == "english"
      @articles = Article.by_search_english_term(search_term)
    else
      @articles = Article.by_search_hindi_term(search_term)
    end

    respond_to do |format|
      format.html {}
      format.json { head :no_content }
    end
    render layout: false
  end

  def search_articles
    if params[:search_type] == 'by_attribute'
      queryy = Article.by_attributes_query(params[:author_id], params[:context_id],
        params[:article_type_id], params[:theme_chapter_id], params[:contributor_id]
      )
      @articles = Article.where(queryy).page(params[:page])
    elsif params[:search_type] == 'by_id'
      @articles = Article.where(id: params[:article_id]).page(params[:page])
    elsif params[:search_type] == 'by_term'
      search_term = params[:term]
      if params[:search_in] == "english"
        @articles = Article.by_search_english_term(search_term).page(params[:page])
      else
        @articles = Article.by_search_hindi_term(search_term).page(params[:page])
      end
    else
      @articles = Article.order("created_at desc").page(params[:page])
    end

    respond_to do |format|
      format.html {}
      format.js {}
    end
  end
  
end
