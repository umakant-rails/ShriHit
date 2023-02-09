class PanchangsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_panchang, only: %i[show panchang_pdf]

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
    @next_month_link = "/panchangs/#{@panchang.id}?start_date="+next_month_wday.strftime("%d/%m/%Y")
    @last_month_link = "/panchangs/#{@panchang.id}?start_date="+last_month_wday.strftime("%d/%m/%Y")
    @panchang_tithiya = PanchangTithi.where("panchang_id=? and date between ? and ?",@panchang.id,
      @cur_date.beginning_of_month, @cur_date.end_of_month).order("date asc")

    @panchang_utsav = PanchangTithi.where("date between ? and ? and description != ''",
      @cur_date.beginning_of_month, @cur_date.end_of_month).order("date asc").to_a
  end

  def panchang_pdf
    @panchang_tithis = @panchang.panchang_tithis.order("date ASC")
    @week_days = Date::DAYNAMES.rotate(1).map{ | d | d[0,3] }
    # debugger
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: @panchang.title,
          save_to_file: @panchang.title,
          template: "public/panchangs/panchang_pdf",
          layout: "panchang_layout",
          margin: {top: 14, bottom: 14, left: 4, right: 4},
          title:  @panchang.title,
          header: {
            html: {
              template: 'public/panchangs/pdf_content/header',
              layout:   'pdf_plain'
            },
            line: true,
            spacing: 4
          },
          footer: {
            html: {
              template: 'public/panchangs/pdf_content/footer',
              layout:   'pdf_plain'
            },
            line: true,
            spacing: 4
          },
          background: true,
          show_as_html: false,
          page_size: "A4",
          encoding:"UTF-8",
          print_media_type: true
      end
    end
  end

  private

  def set_panchang
    @panchang = Panchang.find(params[:id])
  end

end
