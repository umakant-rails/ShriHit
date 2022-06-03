class Public::AuthorsController < Public::AppController

  def index
    @authors = Author.order("name ASC").page(params[:page])
  end

  def show
    @author = Author.find(params[:id])
    @articles = @author.articles.limit(11)
  end

end