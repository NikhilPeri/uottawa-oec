class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def twilio
    render json: nil, status: 200
  end

  private

  def twilio_params
    params.permit('From', 'Body')
  end
end
