include TwilioHelper

class NotificationJob < ApplicationJob
  queue_as :default

  def perform(*args)
    upcoming_patients.each do |patient|
      next unless patient.waiting?
      patient.notify!

      body = <<-EOF
      Hey #{patient.first_name},
      Your 20 minutes form your appointment

      Your expected time to visit the ER is #{patient.predicted_time}

      See you soon!
      EOF

      TwilioHelper.send_message(
        to: patient.phone_number,
        body: body
      )
    end
  end

  def upcoming_patients
    Patient.where(
      "predicted_time <= ? AND predicted_time >= ?",
      DateTime.now + 20.minutes,
      DateTime.now
    )
  end
end
