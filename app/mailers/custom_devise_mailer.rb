class CustomDeviseMailer < Devise::Mailer
  layout 'mailer' 

  def headers_for(action, opts)
    super.merge!({template_path: 'users/mailer'})
  end

end