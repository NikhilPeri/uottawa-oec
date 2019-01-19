module TwilioHelper
  LEAVE_COMMAND = 'LEAVE'
  def send_message(to:, body:)
    begin
      twilio_client.api.account.messages.create(
        from: ENV['TWILIO_PHONE_NUMBER'],
        to: to,
        body: body
      )
    rescue
      return
    end
  end

  def inbound_messages
    twilio_client.api.account.messages.list.select do |message|
      message.from != ENV['TWILIO_PHONE_NUMBER']
    end
  end

  def twilio_client
    @twilio_client ||= Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_AUTH_TOKEN']
    )
  end
end
