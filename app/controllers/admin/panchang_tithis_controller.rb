class Admin::PanchangTithisController < ApplicationController
  before_action :authenticate_user!
	before_action :verify_admin
  before_action :set_panchang, only: %i[new create edit udpate destroy get_tithis ]
	before_action :set_panchang_tithi, only: %i[edit update destroy ]

  def new
    last_tithi = nil
		if params[:start_date].present?
			@cur_date = Date.parse(params[:start_date])
		else
      last_tithi = @panchang.panchang_tithis.order("date ASC").last
      @cur_date = last_tithi.present? ? last_tithi.date : Date.today
		end

		@panchang_tithi = @panchang.panchang_tithis.new
    set_calendar_dates
    
    if last_tithi.blank?
      @hindi_months = [@panchang.hindi_months.order("hindi_months.order ASC")[0]]
    elsif last_tithi.paksh == "शुक्ळ पक्ष" && last_tithi.tithi == 15
      @hindi_months = @panchang.hindi_months.where("hindi_months.order=?",last_tithi.hindi_month.order+1)
    else
      @hindi_months = [last_tithi.hindi_month]
    end

    @all_tithis = PanchangTithi.get_all_tithis
    @month_tithis = @hindi_months[0].month_tithis
	end

	def create
    error_msg, success_msg = '', ''
		params[:panchang_tithi][:year] = params[:panchang_tithi][:date].split("/")[2].to_i
		tithi_txt = params[:panchang_tithi][:tithi]
		params[:panchang_tithi][:tithi] = tithi_txt[tithi_txt.rindex(" "), tithi_txt.length].strip
		params[:panchang_tithi][:paksh] = tithi_txt[0,tithi_txt.rindex(" ")].strip

    last_tithi = @panchang.panchang_tithis.order("date ASC").order("tithi ASC").last
    new_tithi = @panchang.panchang_tithis.new(panchang_tithi_params)

    if (new_tithi.paksh == last_tithi.paksh) && (new_tithi.tithi-last_tithi.tithi > 1 || new_tithi.tithi-last_tithi.tithi < 0)
      # check for tithi must be continue on regular basis for entry in panchang tithi
      flash[:error] = "कृपया तिथियों को क्रमवार रूप से दर्ज करे, अंतिम दर्ज की गई तिथि #{last_tithi.paksh} #{last_tithi.tithi} है
      नई तिथि #{last_tithi.paksh} #{new_tithi.tithi} के स्थान पर तिथि #{last_tithi.paksh} #{(last_tithi.tithi+1)%15} होनी चाहिए."
    elsif (new_tithi.paksh != last_tithi.paksh) && (new_tithi.tithi-last_tithi.tithi != -14)
      # check for tithi must be continue after ending paksh for entry in panchang tithi
      flash[:error] = "कृपया तिथियों को क्रमवार रूप से दर्ज करे, अंतिम दर्ज की गई तिथि #{last_tithi.paksh} #{last_tithi.tithi} है
      नई तिथि #{new_tithi.paksh} #{new_tithi.tithi} के स्थान पर तिथि #{new_tithi.paksh} #{(last_tithi.tithi+1)%15} होनी चाहिए."
    elsif (new_tithi.date-last_tithi.date).to_i > 1 || (new_tithi.date-last_tithi.date).to_i < 0
      # check for date must be continue for entry in panchang tithi
      flash[:error] = "कृपया दिनांक को क्रमवार रूप से दर्ज करे, अंतिम दर्ज की गई दिनांक #{last_tithi.date.strftime('%d/%b%Y')} है नई दिनांक #{new_tithi.date.strftime('%d/%b%Y')} के स्थान पर तिथि #{(last_tithi.date+1.day).strftime('%d/%b%Y')} होनी चाहिए"
    elsif PanchangTithi.where("date = ? and tithi = ?", new_tithi.date, new_tithi.tithi).present?
      flash[:error] = "इस दिनांक #{new_tithi.date.strftime("%d/%m/%Y")} और इस तिथि #{new_tithi.paksh} #{new_tithi.tithi} के साथ एंट्री की जा चुकी है."
    elsif new_tithi.save
			flash[:notice] = "तिथि की एंट्री सफलतापूर्वक की गई."
		else
			flash[:error] = "तिथि एंट्री की प्रकिया असफल हो गई है."
    end

    respond_to do |format|
      if flash[:success]
        format.html { redirect_to new_admin_panchang_panchang_tithi_path}
        format.js {}
      else
        format.html { redirect_to new_admin_panchang_panchang_tithi_path}
        format.js {}
      end
    end
	end

  def edit
		@cur_date = @panchang_tithi.date
    set_calendar_dates
    @all_tithis = PanchangTithi.get_all_tithis
    @month = @panchang.hindi_months.where("hindi_months.id=?", @panchang_tithi.hindi_month_id)
    @month_tithis = @month[0].month_tithis
    @hindi_months = @panchang.hindi_months.order("hindi_months.order ASC")

		respond_to do |format|
      format.html {}
      format.js {}
    end
	end

	def update
    params[:panchang_tithi][:year] = params[:panchang_tithi][:date].split("/")[2].to_i
		tithi_txt = params[:panchang_tithi][:tithi]
		params[:panchang_tithi][:tithi] = tithi_txt[tithi_txt.rindex(" "), tithi_txt.length].strip
		params[:panchang_tithi][:paksh] = tithi_txt[0,tithi_txt.rindex(" ")].strip

    if @panchang_tithi.update(panchang_tithi_params)
      flash[:success] = "तिथि को सफलतापूर्वक अद्यतित कर दिया गया है."
		else
			flash[:error] = "तिथि को अद्यतित करने की प्रकिया असफल हो गई है."
    end

    respond_to do |format|
      format.html {redirect_to new_admin_panchang_panchang_tithi_path}
      format.js {}
    end
	end

  def destroy
    @cur_date = @panchang_tithi.date
    set_calendar_dates

    if @panchang_tithi.destroy
      @panchang_tithi = @panchang.panchang_tithis.new
      flash[:success] = "तिथि को सफलतापूर्वक डिलीट कर दिया गया है."
		else
			flash[:error] = "तिथि को डिलीट करने की प्रकिया असफल हो गई है."
    end
    respond_to do |format|
      format.html {redirect_to new_admin_panchang_panchang_tithi_path}
      format.js {}
    end
  end

  def get_tithis

		@month = @panchang.hindi_months.where("hindi_months.id=?", params[:month_id])
		@all_tithis = PanchangTithi.get_all_tithis
		@month_tithis = @month[0].month_tithis

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

  	def panchang_tithi_params
  		params.fetch(:panchang_tithi, {}).permit(:date, :tithi, :paksh, :description, :title, :year,
  			:panchang_id,	:hindi_month_id, :coupled_with_dates)
  	end

    def set_panchang
      @panchang = Panchang.find(params[:panchang_id])
    end

    def set_panchang_tithi
      @panchang_tithi = PanchangTithi.find(params[:id])
    end

    def set_calendar_dates

      #@cur_date += 1.days until @cur_date.wday == 1
      if @cur_date == @cur_date.end_of_month
        @cur_date = @cur_date.next_week
      end
      next_month_wday =  @cur_date.next_month.beginning_of_month
      next_month_wday += 1.days until next_month_wday.wday == 1
      last_month_wday =  @cur_date.last_month.beginning_of_month
      last_month_wday += 1.days until last_month_wday.wday == 1

      @week_days = Date::DAYNAMES.rotate(1).map{ | d | d[0,3] }
      @next_month_link = "/admin/panchangs/#{@panchang.id}/panchang_tithis/new?start_date="+next_month_wday.strftime("%d/%m/%Y")
      @last_month_link = "/admin/panchangs/#{@panchang.id}/panchang_tithis/new?start_date="+last_month_wday.strftime("%d/%m/%Y")
      @panchang_tithiya = PanchangTithi.where("panchang_id=? and date between ? and ?",@panchang.id,
        @cur_date.beginning_of_month, @cur_date.end_of_month).order("date asc")
    end

end
