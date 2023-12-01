class Public::ScripturesController < ApplicationController

  def index
    @scripture_types = ScriptureType.left_joins(:scriptures).uniq
    respond_to do |format|
      format.html {}
    end
  end

  def show
    @scripture = Scripture.where(name_eng: params[:id].strip).first rescue nil
    if @scripture.present? && @scripture.scripture_type.name == "रसिक वाणी"
      @articles = @scripture.articles.order("index")
    elsif @scripture.present? && @scripture.scripture_type.name == "कथायें"
      @articles = @scripture.stories.order("index")
    end

    respond_to do |format|
      format.html {}
    end
  end

end
