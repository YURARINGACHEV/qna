class NotificationService
  def send_notification(answer)
    subscriptions = answer.question.subscriptions
    subscriptions.find_each do |subscription|
      NotifcationMailer.notification(subscription.user, answer).deliver_later
    end
  end
end