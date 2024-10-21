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
      # Invoice Container Styling
      pdf.fill_color 'FFFFFF'  # White background for the container
      pdf.stroke_color 'DDDDDD'  # Light border
      pdf.stroke_bounds
      pdf.move_down 20
  
      # Invoice Header
      pdf.fill_color '007BFF'
      pdf.font_size 30 do
        pdf.text "Booking Invoice", style: :bold, align: :center
      end
      pdf.move_down 10
      pdf.fill_color '000000'
      pdf.text "Thank you for your booking!", size: 18, align: :center, style: :italic
      pdf.move_down 20
  
      # Booking Info
      pdf.font_size 14
      pdf.text "Car Name: #{booking.car.name}", size: 16, style: :bold
      pdf.text "Car Model: #{booking.car.model}", size: 12
      pdf.text "Customer Email: #{booking.user.email}", size: 12
      pdf.text "Booking Date: #{booking.created_at.strftime('%d %B %Y')}", size: 12
      pdf.text "Start Date: #{booking.start_date.strftime('%d %B %Y')}", size: 12
      pdf.text "End Date: #{booking.end_date.strftime('%d %B %Y')}", size: 12
      pdf.move_down 20
  
      # Pricing Details
      pdf.fill_color '007BFF'
      pdf.text "Pricing Details", size: 18, style: :bold
      pdf.move_down 10
      pdf.fill_color '000000'
      
      total_days = (booking.end_date - booking.start_date).to_i
      days_text = total_days == 1 ? 'day' : 'days'
      pdf.text "Total Price: #{'%.2f' % booking.total_price}", size: 12
      pdf.move_down 20
  
      # Thank You Note
      pdf.fill_color '007BFF'
      pdf.text "Thank you for choosing Zoom Car!", size: 12, style: :italic, align: :center
      pdf.move_down 10
      pdf.fill_color '000000'
  
      # Footer
      pdf.text "For any queries, contact us at support@zoomcar.com", size: 10, align: :center
      pdf.text "Visit our website: www.zoomcar.com", size: 10, align: :center
    end.render
  end
  



end
