class Public::StrotaController < ApplicationController

  def index 
    @strota_types = StrotaType.all
    @strotas = Strotum.joins(:strota_type)
    @sants = Author.where("biography!= ''").limit(5) rescue []
    @scriptures = Scripture.all.limit(5)
  end

  def show
    @strotum = Strotum.where(name: params[:id]).first 
    @articles = @strotum.strota_articles rescue []
  end

end
