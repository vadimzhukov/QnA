class EmailRegistrationMailer < ApplicationMailer
  def confirm_email_registration(email_registration)
    @email_registration = email_registration
    @confirmation_token = email_registration.confirmation_token

    mail to: @email_registration.email, subject: "Confirm your registration on QNA"
  end
end
