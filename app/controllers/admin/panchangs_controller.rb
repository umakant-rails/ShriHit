class Admin::PanchangsController < ApplicationController
	before_action :authenticate_user!
	before_action :verify_admin
	before_action :set_panchang, only: %i[ show edit update destroy add_purshottam_mas remove_purshottam_mas]

	def index
    @panchangs = Panchang.all
	end

  def new
    @panchang = Panchang.new
  end

  def create
		month_order = 0
  	@panchang = Panchang.new(panchang_params)
  	if @panchang.save
    	HindiMonth::MONTH.each do | month |
				month_order = month_order + 1
				@panchang.hindi_months.create({name: month, order: month_order, is_purshottam_month: false})
				if month == params[:purshottam_month]
					month_order = month_order + 1
					@panchang.hindi_months.create({name: "#{month}", order: month_order, is_purshottam_month: true})
				end
			end
    	flash[:success] = "पंचांग की एंट्री सफलतापूर्वक की गई."
    else
    	flash[:error] = "पंचांग जोड़ने की प्रकिया असफल हो गई है."
    end

  	respond_to do |format|
  		format.html {redirect_to admin_panchangs_path}
      format.js {}
    end

  end

	def show
		@hindi_months = @panchang.hindi_months.includes(:panchang_tithis).order("hindi_months.order ASC")

    @cur_date = params[:start_date].blank? ? Date.today : Date.parse(params[:start_date])
    @cur_date += 1.days until @cur_date.wday == 1

    next_month_wday =  @cur_date.next_month.beginning_of_month
    next_month_wday += 1.days until next_month_wday.wday == 1
    last_month_wday =  @cur_date.last_month.beginning_of_month
    last_month_wday += 1.days until last_month_wday.wday == 1

    @week_days = Date::DAYNAMES.rotate(1).map{ | d | d[0,3] }
    @next_month_link = "/admin/panchangs/#{@panchang.id}?start_date="+next_month_wday.strftime("%d/%m/%Y")
    @last_month_link = "/admin/panchangs/#{@panchang.id}?start_date="+last_month_wday.strftime("%d/%m/%Y")
    @panchang_tithiya = PanchangTithi.where("panchang_id=? and date between ? and ?",@panchang.id,
      @cur_date.beginning_of_month, @cur_date.end_of_month).order("date asc")

	end

  def edit
  end

  def update
    new_purshottam_month = params[:purshottam_month]
    if @panchang.update(panchang_params)
    	flash[:success] = "पंचांग अद्यतन की एंट्री सफलतापूर्वक की गई."
    else
    	flash[:error] = "पंचांग अद्यतन की प्रकिया असफल हो गई है."
    end

    respond_to do |format|
  		format.html {redirect_to admin_panchangs_path}
      format.js {}
    end
  end

	def destroy
    @panchang.destroy
    respond_to do |format|
      format.html { redirect_to admin_panchangs_path, notice: "पंचांग को सफलतापूर्वक डिलीट कर दिया गया है." }
      format.json { head :no_content }
    end
  end

  def populate_panchang
		@panchang_month = @panchang.hindi_months.where("id=?", params[:hindi_month_id])
		if @panchang_month.present?
	    begin
				ActiveRecord::Base.transaction do
	        tithiya = PanchangTithi.get_tithis_of_month(@panchang, @panchang_month[0])
					tithiya.each do | tithi |
						new_tithi = @panchang_month[0].panchang_tithis.new(tithi)
						new_tithi.save!(validate: false)
					end
					flash[:success] = "पंचांग में तिथि की एंट्री सफलतापूर्वक कर दी गई है."
				end
	    rescue => error
	      flash[:error] = "पंचांग में तिथि की एंट्री  करने की प्रकिया असफल हो गई है"
	    end
		else
			flash[:error] = "पंचांग में तिथि की एंट्री  करने की प्रकिया असफल हो गई है"
		end
		respond_to do |format|
      format.html { redirect_to admin_panchang_path(@panchang, populate: true) }
      format.js {}
    end
  end

	def add_purshottam_mas
		@panchang_month = @panchang.hindi_months.where("id=?", params[:hindi_month_id])[0]
		if @panchang_month.present?
			@panchang.update_purshottam_month(@panchang_month.name)
		end

		respond_to do |format|
      format.html { redirect_to admin_panchang_path(@panchang, populate: true) }
      format.js {}
    end
	end

	def remove_purshottam_mas
		@panchang.update_purshottam_month('');
		respond_to do |format|
      format.html { redirect_to admin_panchang_path(@panchang, populate: true) }
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
    params.fetch(:panchang, {}).permit(:title, :vikram_samvat, :panchang_type, :has_purshottam_month, :purshottam_month, :description)
  end

  def set_panchang
    @panchang = Panchang.find(params[:id])
  end

end
