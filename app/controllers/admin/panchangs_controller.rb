class Admin::PanchangsController < ApplicationController
	before_action :authenticate_user!
	before_action :verify_admin
	before_action :set_tithi, only: %i[ show edit update destroy]

	def index
		# date = Date.today
		# start_date = date.beginning_of_month
		# end_date = Date.new(date.year, date.month, -1)
		# @panchange_tithiya = Panchang.where("date between ? and ?", date.beginning_of_month, date.end_of_month).order("date asc")
		# respond_to do |format|
  	# 	format.html {}
    #   format.js {}
    # end

    @cur_date = params[:start_date].blank? ? Date.today : Date.parse(params[:start_date])

    next_month_wday = @cur_date.next_month.beginning_of_month
    next_month_wday += 1.days until next_month_wday.wday == 1
    last_month_wday = @cur_date.last_month.beginning_of_month
    last_month_wday += 1.days until last_month_wday.wday == 1

    @week_days = Date::DAYNAMES.rotate(1).map{ | d | d[0,3] }
    @next_month_link = '/admin/panchangs?start_date='+next_month_wday.strftime("%d/%m/%Y")
    @last_month_link = '/admin/panchangs?start_date='+last_month_wday.strftime("%d/%m/%Y")
    @panchange_tithiya = Panchang.where("date between ? and ? and description is not null",
			@cur_date.beginning_of_month, @cur_date.end_of_month).order("date asc")
	end

  def new
    @cur_date = params[:start_date].blank? ? Date.today : Date.parse(params[:start_date])
    @cur_date += 1.days until @cur_date.wday == 1

    next_month_wday =  @cur_date.next_month.beginning_of_month
    next_month_wday += 1.days until next_month_wday.wday == 1
    last_month_wday =  @cur_date.last_month.beginning_of_month
    last_month_wday += 1.days until last_month_wday.wday == 1

    @week_days = Date::DAYNAMES.rotate(1).map{ | d | d[0,3] }
    @next_month_link = '/admin/panchangs/new?start_date='+next_month_wday.strftime("%d/%m/%Y")
    @last_month_link = '/admin/panchangs/new?start_date='+last_month_wday.strftime("%d/%m/%Y")
    @tithi = Panchang.new
  end

  def create
  	params[:panchang][:year] = Date.parse(params[:panchang][:date]).year
  	params[:panchang][:title] = params[:panchang][:panchang_month] + ", " + params[:panchang][:paksh] + " - " + params[:panchang][:panchang_tithi]

  	@panchang = Panchang.new(panchang_params)

  	if @panchang.save!
    	@tithi = Panchang.new
    	flash[:success] = "तिथि की एंट्री सफलतापूर्वक की गई."
    else
    	flash[:error] = "तिथि जोड़ने की प्रकिया असफल हो गई है."
    end

  	respond_to do |format|
  		format.html {}
      format.js {}
    end

  end

  def edit
  	@cur_date = params[:start_date].blank? ? Date.today : Date.parse(params[:start_date])
    @cur_date += 1.days until @cur_date.wday == 1

    next_month_wday = (@cur_date + 1.month).beginning_of_month
    next_month_wday += 1.days until next_month_wday.wday == 1
    last_month_wday = (@cur_date - 1.month).beginning_of_month
    last_month_wday += 1.days until last_month_wday.wday == 1

    @week_days = Date::DAYNAMES.rotate(Date.today.wday).map{ | d | d[0,3] }
    @next_month_link = '/admin/panchangs/new?start_date='+next_month_wday.strftime("%d/%m/%Y")
    @last_month_link = '/admin/panchangs/new?start_date='+last_month_wday.strftime("%d/%m/%Y")
  end

   def update

   	if @tithi.update(panchang_params)
    	flash[:success] = "तिथि अद्यतन की एंट्री सफलतापूर्वक की गई."
    else
    	flash[:error] = "तिथि अद्यतन की प्रकिया असफल हो गई है."
    end

    respond_to do |format|
  		format.html {}
      format.js {}
    end
  end


  private

  def verify_admin
    if !current_user.is_admin && !current_user.is_super_admin
      redirect_to new_user_session_path
    end
  end

  def panchang_params
  	params.fetch(:panchang, {}).permit(:date, :panchang_tithi, :panchang_month,
        :paksh, :title, :vikram_samvat, :description, :year, :panchang_type)
  end

  def set_tithi
    @tithi = Panchang.find(params[:id])
  end

end
