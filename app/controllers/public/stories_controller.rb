class Public::StoriesController < ApplicationController
  before_action :set_required_data

  def index
    @stories = Story.all.page(params[:page]).per(10)
  end

  def show
    @story = Story.where(title: params[:id])[0] rescue nil
    @stories = Story.where("id not in(?)", @story.id)
  end

  private
    
    def set_required_data
      @sants = Author.where("biography!= ''").limit(5) rescue []
      @scriptures = Scripture.all.limit(5)
    end

end
