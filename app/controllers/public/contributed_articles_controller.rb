class Public::ContributedArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]
  before_action :verify_admin, except: [:new, :create]
  before_action :set_contributed_article, only: %i[edit update destroy]

  def index
    @c_articles = ContributedArticle.all.page(params[:page])

    respond_to do |format|
      format.html {}
      format.json { head :no_content }
    end
  end

  def hold_and_next
    ContributedArticle.find(params[:contributed_article_id]).update(is_hold: true)
    redirect_to contributed_article_new_articles_path
  end

  def destroy
    respond_to do |format|
      if @c_article.destroy
        if params[:redirect] == "true"
          redirect_to contributed_article_new_articles_path
        else
          format.html { redirect_to public_contributed_articles_path, notice: "रचना को सफलतापूर्वक डिलीट कर दिया गया हैै" }
        end
      end
    end
  end

  private

    def verify_admin
      if !current_user.is_admin && !current_user.is_super_admin
        redirect_back_or_to homes_path
      end
    end

end
