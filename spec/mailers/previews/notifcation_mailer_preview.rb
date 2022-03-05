# Preview all emails at http://localhost:3000/rails/mailers/notifcation_mailer
class NotifcationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/notifcation_mailer/notification
  def notification
    NotifcationMailer.notification
  end

end
