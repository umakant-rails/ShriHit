class Public::ArticleTypesController < ApplicationController

 def index
    @article_types = ArticleType.order("name ASC")
  end

  def show
    if(params[:id].blank? && params[:article_type_name].present?)
      @article_type = ArticleType.where(name: params[:article_type_name].strip)[0]
    elsif params[:id].present?
      @article_type = ArticleType.find(params[:id])
    end
    if @article_type.present?
      @articles_by_type = @article_type.articles.page(params[:page]) rescue []
    else
      flash[:notice] = "आपके द्वारा जिस रचना प्रकार की जानकारी चाही गई थी, वह उपलब्ध नहीं है |"
      redirect_back_or_to root_path
    end
  end

end
