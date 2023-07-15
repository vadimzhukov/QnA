class EmailRegistrationMailerPreview < ActionMailer::Preview
  def confirm_email_registration
    email_registratiion = EmailRegistration.new(email: Email.first)

    EmailRegistrationMailer.confirm_email_registration(email_registration)
  end
end
