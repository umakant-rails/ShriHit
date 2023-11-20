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
      @rasik_vanis = Scripture.joins(:scripture_type).where("scripture_types.name =? ", "रसिक वाणी").limit(6)
      @stories_books  = Scripture.joins(:scripture_type).where("scripture_types.name =? ", "कथायें").limit(6)
    end

end
