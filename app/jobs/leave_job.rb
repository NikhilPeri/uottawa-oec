include TwilioHelper

class LeaveJob < ApplicationJob
  queue_as :default

  def perform(*args)
    leave_requests.each do |request|
      patient = Patient.find_by(phone_number: request.from)
      next if patient.nil? || patient.created_at > request.date_created
      patient.cancel! unless patient.canceled?

      body = <<-EOF
      Hey #{patient.first_name},

      Your have been removed from WaitER
      EOF

      TwilioHelper.send_message(
        to: patient.phone_number,
        body: body
      )
    end
  end

  def leave_requests
    TwilioHelper.inbound_messages.select do |message|
      message.body.upcase == TwilioHelper::LEAVE_COMMAND
    end
  end
end
