class Public::AppController < ApplicationController
  before_action :set_required_data

  private

  def set_required_data
    @article_types = ArticleType.order("name ASC")
    @contexts = Context.order("name ASC")
    @authors = Author.order("name ASC")
    @contributors = User.order("username ASC")
  end

end
