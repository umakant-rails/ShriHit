class Public::StrotaController < ApplicationController
  before_action :set_required_data

  def index 
    @strota_types = StrotaType.all
    @strotas = Strotum.joins(:strota_type)
  end

  def show
    @strotum = Strotum.where(title: params[:id]).first 
    @articles = @strotum.strota_articles.order("index ASC") rescue []

    @strota = Strotum.where("strota_type_id = ? and id not in (?)",
      @strotum.strota_type_id, @strotum.id) rescue []
    if @strotum.blank?
      redirect_back_or_to public_strota_path 
    end
  end

  def get_strota_by_type
    @strota_types = StrotaType.all
    @strota_type = StrotaType.where(name: params[:strota_type]).first rescue nil
    @strotas = @strota_type.strota rescue []  
  end

  private
    
    def set_required_data
      @sants = Author.where("biography!= ''").limit(5) rescue []
      @scriptures = Scripture.all.limit(5)
    end

end
