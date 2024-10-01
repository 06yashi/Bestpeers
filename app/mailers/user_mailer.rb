class UserMailer < ApplicationMailer
  def booking_notification(user)
    mail(to: user.email, subject: 'Your Booking is Successful!', from: 'shrivastavayanshi23@gmail.com')
  end
end
