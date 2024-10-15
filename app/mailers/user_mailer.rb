class UserMailer < ApplicationMailer
  default from: 'shrivastavayanshi23@gmail.com'

  def booking_notification(user)
    @user = user
    mail(to: @user.email, subject: 'Booking Confirmation')
  end

  def login_notification(user)
    @user = user
    mail(to: @user.email, subject: 'Login Successful')
  end
end
