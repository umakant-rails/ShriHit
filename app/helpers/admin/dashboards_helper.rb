module Admin::DashboardsHelper

  def get_total_grouped_record(records)
    total = 0
    records.each do | key, value |
      total = total + value
    end
    total
  end
end
