class UserMailer < ApplicationMailer
  default from: 'yshrivastava@bestpeers.com'
  

  def booking_notification(user, booking)
    @user = user
    @booking = booking
    attachments["receipt_#{@booking.id}.pdf"] = generate_pdf(@booking)
    mail(to: @user.email, subject: "Booking Confirmation")
  end

  private


  def generate_pdf(booking)
    Prawn::Document.new do |pdf|
      # Set background color for the header
      pdf.fill_color 'F2F2F2'  # Light gray color
      pdf.rectangle([0, pdf.cursor], pdf.bounds.width, 60)
      pdf.fill
  
      # Title
      pdf.font_size 30 do
        pdf.fill_color '0056B3'  # Dark blue color for title
        pdf.text "Booking Confirmation", style: :bold, align: :center
        pdf.fill_color '000000'  # Reset to black for other texts
      end
      pdf.move_down 40
  
      # Greeting
      pdf.text "Dear User,", size: 16, style: :italic
      pdf.move_down 10
  
      # Booking Confirmation Message
      pdf.text "Your booking has been successfully completed!", size: 12, align: :center
      pdf.move_down 20
  
      # Car Details Section
      pdf.text "Car Details", size: 16, style: :bold, color: '0056B3'
      pdf.move_down 10
      pdf.text "Car: #{booking.car.name} (#{booking.car.model})", size: 12
      pdf.text "Car ID: #{booking.car.id}", size: 12
      pdf.move_down 10
  
      # Dates and Price Section
      pdf.text "Booking Details", size: 16, style: :bold, color: '0056B3'
      pdf.move_down 10
      pdf.text "Start Date: #{booking.start_date.strftime("%B %d, %Y")}", size: 12
      pdf.text "End Date: #{booking.end_date.strftime("%B %d, %Y")}", size: 12
      pdf.text "Total Price: $#{'%.2f' % booking.total_price}", size: 12
      pdf.text "Status: #{booking.status.capitalize}", size: 12
      pdf.move_down 20
  
      # Thank You Note
      pdf.text "Thank you for choosing Zoom Car!", size: 12, style: :italic, align: :center, color: '007BFF'  # Blue color for emphasis
      pdf.move_down 10
  
      # Footer with Contact Information
      pdf.text "For any queries, contact us at support@zoomcar.com", size: 10, align: :center
      pdf.text "Visit our website: www.zoomcar.com", size: 10, align: :center
    end.render
  end
  



end
