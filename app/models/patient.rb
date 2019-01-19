class Patient < ApplicationRecord
  include AASM

  before_save :compute_priority
  phony_normalize :phone_number, default_country_code: 'CAN'

  aasm do
    state :waiting, initial: true
    state :canceled
    state :notified
    state :completed, before_enter: -> { self.complete_at = Time.now }

    event :cancel do
      transitions from: [:notified, :waiting], to: :canceled
    end

    event :notify do
      transitions from: :waiting, to: :notified
    end

    event :complete do
      transitions from: [:notified, :waiting], to: :completed
    end
  end

  private

  def compute_priority
    self.priority = rand
    self.predicted_time ||= Time.now + 23.minutes
  end
end
