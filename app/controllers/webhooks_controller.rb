include TwilioHelper

class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def twilio
    raise unless twilio_params['Body'] == TwilioHelper::LEAVE_COMMAND
    raise if patient.nil?

    patient.cancel! unless patient.canceled?

    body = <<-EOF
    Hey #{patient.first_name},

    Your have been removed from WaitER
    EOF

    TwilioHelper.send_message(
      to: patient.phone_number,
      body: body
    )
    render json: nil, status: 200
  rescue
    TwilioHelper.send_message(
      to: patient.phone_number,
      body: "Sorry we don't understand"
    )
    render json: nil, status: 422
  end

  private

  def patient
    @patient ||= Patient.find_by(phone_number: twilio_params['From'].gsub('+1', ''))
  end

  def twilio_params
    params.permit('From', 'Body')
  end
end
