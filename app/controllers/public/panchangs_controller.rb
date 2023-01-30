class Public::PanchangsController < ApplicationController
  before_action :set_panchang, only: %i[show]

  def index
    @panchangs = Panchang.all.order("created_at DESC")
  end

  def show
    @cur_date = params[:start_date].blank? ? Date.today : Date.parse(params[:start_date])
    @cur_date += 1.days until @cur_date.wday == 1

    next_month_wday =  @cur_date.next_month.beginning_of_month
    next_month_wday += 1.days until next_month_wday.wday == 1
    last_month_wday =  @cur_date.last_month.beginning_of_month
    last_month_wday += 1.days until last_month_wday.wday == 1

    @week_days = Date::DAYNAMES.rotate(1).map{ | d | d[0,3] }
    @next_month_link = "/pb/panchangs/#{@panchang.id}?start_date="+next_month_wday.strftime("%d/%m/%Y")
    @last_month_link = "/pb/panchangs/#{@panchang.id}?start_date="+last_month_wday.strftime("%d/%m/%Y")
    @panchang_tithiya = PanchangTithi.where("panchang_id=? and date between ? and ?",@panchang.id,
      @cur_date.beginning_of_month, @cur_date.end_of_month).order("date asc")
    
    @panchang_utsav = PanchangTithi.where("date between ? and ? and description != ''",
      @cur_date.beginning_of_month, @cur_date.end_of_month).order("date asc").to_a
  end

  private 

  def set_panchang
    @panchang = Panchang.find(params[:id])
  end

end
