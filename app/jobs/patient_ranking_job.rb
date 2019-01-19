class PatientRankingJob < ApplicationJob
  queue_as :default

  MAX_WAIT_TIME = 120.minute
  TIME_TO_FRONT_DESK = 5.minutes

  def perform(*args)
    active_patients.sort_by(&:risk_score).each_with_index do |patient, index|
      relative_rank = index.to_f / active_patients.count

      patient.priority = relative_rank
      patient.predicted_time = Time.now + TIME_TO_FRONT_DESK + (1-relative_rank) * MAX_WAIT_TIME

      patient.save!
    end
  end

  def active_patients
    @active_patients ||= Patient.where(aasm_state: [:waiting, :notified])
  end
end
