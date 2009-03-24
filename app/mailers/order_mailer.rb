class OrderMailer < ApplicationMailer
    layout 'order_mailer'
    def order_email(order)
        recipients   order.email
        from          "info@handmade-weddingcards.com" #can use APP_CONFIG[...] to make it customizable
        subject      "Order Placement (Order ID: #{order.id}) - Handmade Wedding Cards"
        sent_on      Time.now
        bcc          "Bjorn <bjorn@fairenterprise.net>, Watabaran <info@watabaran.org>"
        body        :order => order
        content_type "text/html"
        
    end
end