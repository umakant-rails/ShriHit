module Admin::PanchangsHelper

  def get_utsav(tithiya, dt)
    utsav = tithiya.present? ? tithiya.where("date=?", dt)[0] : nil

    if utsav.blank?
      return ""
    end

    if utsav.panchang_tithi == 11.to_s and utsav.paksh == 'शुक्ळ पक्ष'
      return "एकादशी"
    elsif utsav.panchang_tithi == 11.to_s and utsav.paksh == 'कृष्ण पक्ष'
      return "एकादशी"
    elsif utsav.panchang_tithi == 15.to_s and utsav.paksh == 'शुक्ळ पक्ष'
      return "पूर्णिमा"
    elsif utsav.panchang_tithi == 15.to_s and utsav.paksh == 'कृष्ण पक्ष'
      return "अमावस्या"
    else
      return utsav.paksh + "-" + utsav.panchang_tithi
    end
  end

end
