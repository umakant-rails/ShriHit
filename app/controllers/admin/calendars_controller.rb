class Admin::CalendarsController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin

  def new
    @cur_date = params[:start_date].blank? ? Date.today : Date.parse(params[:start_date])
    @cur_date += 1.days until @cur_date.wday == 1

    next_month_wday = (@cur_date + 1.month).beginning_of_month
    next_month_wday += 1.days until next_month_wday.wday == 1
    last_month_wday = (@cur_date - 1.month).beginning_of_month
    last_month_wday += 1.days until last_month_wday.wday == 1

    @week_days = Date::DAYNAMES.rotate(Date.today.wday).map{ | d | d[0,3] }
    @next_month_link = '/admin/calendars/new?start_date='+next_month_wday.strftime("%d/%m/%Y")
    @last_month_link = '/admin/calendars/new?start_date='+last_month_wday.strftime("%d/%m/%Y")
  end

  private

  def verify_admin
    if !current_user.is_admin && !current_user.is_super_admin
      redirect_to new_user_session_path
    end
  end

end
