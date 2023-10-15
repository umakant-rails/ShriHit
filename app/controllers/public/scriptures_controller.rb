class Public::ScripturesController < ApplicationController

  def index
    @scripture_types = ScriptureType.left_joins(:scriptures).uniq
    respond_to do |format|
      format.html {}
    end
  end

  def show
    @scripture = Scripture.where(name_eng: params[:id].strip).first rescue nil
    if @scripture.present?
      @articles = @scripture.articles.order("index")
    end

    respond_to do |format|
      format.html {}
    end
  end

end
