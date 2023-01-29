module Admin::PanchangsHelper

  def get_utsav(tithiya, dt)
    utsavs = tithiya.present? ? tithiya.where("date=?", dt).order("tithi ASC") : nil
    month, is_utsav_present, tithi = utsavs, nil, ''

    if utsavs.blank?
      return [nil, nil, nil]
    end
    # if dt == Date.parse("16/01/2023")
    #   debugger
    # end

    month = utsavs[0].hindi_month.is_purshottam_month ? utsavs[0].hindi_month.name + "(पुर.)" : utsavs[0].hindi_month.name

    utsavs.each_with_index do | utsav, index |
      tithi = utsav.paksh if (index == 0 && utsav.tithi != 15)
      tithi = tithi + ", " + utsav.paksh if (index == 1 && utsav.tithi == 1)
      if utsav.tithi == 11 and utsav.paksh == 'शुक्ळ पक्ष'
        tithi = tithi + ", " + "एकादशी"
      elsif utsav.tithi == 11 and utsav.paksh == 'कृष्ण पक्ष'
        tithi = tithi + ", " + "एकादशी"
      elsif utsav.tithi == 15 and utsav.paksh == 'शुक्ळ पक्ष'
        tithi = "पूर्णिमा"
      elsif utsav.tithi == 15 and utsav.paksh == 'कृष्ण पक्ष'
        tithi = "अमावस्या"
      else
        tithi = tithi + ((index == 0) ? "-" : ", ") + utsav.tithi.to_s
      end
    end

    utsavs.each do | utsav |
      is_utsav_present = (utsav.description.present? || is_utsav_present)? true : false
    end

    return [ month, is_utsav_present, tithi]
  end

  def get_months_array(months)
    month_array = []
    months.each do |month|
      month_id = month.id
      month_name = month.is_purshottam_month ? "#{month.name} (पुर.)" : month.name
      month_array.push([month_name, month_id])
    end
    return month_array
  end

end
