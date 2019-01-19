class Patient < ApplicationRecord
  include AASM
  serialize :data, HashWithIndifferentAccess

  before_save :compute_priority
  
  phony_normalize :phone_number, default_country_code: 'CAN'

  validates :first_name, :last_name, presence: true

  validate :validate_heart_rate, :validate_respiratory_rate, :validate_body_temp, :validate_age, :validate_oxygen_saturation

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

  # validate if which one required other should be blank
  def validate_heart_rate
    if data["heart_rate"].nil? || !data["heart_rate"].empty?
      heart_rate = data["heart_rate"].to_i
      errors.add(:heart_rate, 'must be a whole number between 0 and 500') if !heart_rate.between?(0, 500) or !heart_rate.is_a? Integer
    else
      errors.add(:heart_rate, 'not present')
    end
  end

  # validate if which one required other should be blank
  def validate_respiratory_rate
    if data["respiratory_rate"].nil? || !data["respiratory_rate"].empty?
      respiratory_rate = data["respiratory_rate"].to_i
      errors.add(:respiratory_rate, 'must be a whole number between 0 and 100') if !respiratory_rate.between?(0, 500) or !respiratory_rate.is_a? Integer
    else
      errors.add(:respiratory_rate, 'not present')
    end
  end

  # validate if which one required other should be blank
  def validate_body_temp
    if data["body_temp"].nil? || !data["body_temp"].empty?
      body_temp = data["body_temp"].to_i
      errors.add(:body_temp, 'must be a whole number between 0 and 50') if !body_temp.between?(0, 500) or !body_temp.is_a? Integer
    else
      errors.add(:body_temp, 'not present')
    end
  end

  def validate_age
    if data["age"].nil? || !data["age"].empty?
      age = data["age"].to_i
      errors.add(:age, 'must be a whole number between 0 and 200') if !age.between?(0, 500) or !age.is_a? Integer
    else
      errors.add(:age, 'not present')
    end
  end

  def validate_oxygen_saturation
    if data["oxygen_saturation"].nil? || !data["oxygen_saturation"].empty?
      oxygen_saturation = data["oxygen_saturation"].to_i
      errors.add(:oxygen_saturation, 'must be a whole number between 0 and 100') if !oxygen_saturation.between?(0, 500) or !oxygen_saturation.is_a? Integer
    else
      errors.add(:oxygen_saturation, 'not present')
    end
  end

  private

  def compute_priority
    self.priority = rand
    self.predicted_time ||= Time.now + 23.minutes
  end
end
