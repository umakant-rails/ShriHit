module CommentsHelper

  def date_format_by_day_n_month(date)
    date = date.to_date
    if date == Date.today
      "Today"
    elsif date == Date.yesterday
      "Yesterday"
    elsif (date > Date.today - 7) && (date < Date.yesterday)
      date.strftime("%A")
    else
      date.strftime("%B %d")
    end
  end

  def date_format_by_hour_n_day(date)
    seconds = (Time.now - date)

    minuts = (seconds/1.minute).round
    hours = (seconds/1.hour).round
    days = (seconds/1.day).round
    months = (seconds/1.month).round

    if minuts < 60
      "#{minuts}m ago"
    elsif hours < 24
      "#{hours}h ago"
    elsif ( hours >= 24) && (months == 0)
      "#{days} day ago"
    elsif months > 0
      "#{months}months ago"
    end
  end

end
