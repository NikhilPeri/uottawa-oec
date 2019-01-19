class Patient < ApplicationRecord
  include AASM
  serialize :data, HashWithIndifferentAccess

  attribute :priority, default: 0.0
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

  def risk_score
    1*((self.data[:heart_rate] || 60 )- 60)**2 +
    1*((self.data[:respiratory_rate] || 90) - 90)**2 +
    1*((self.data[:body_temp] || 40) - 40)**2 +
    1*((self.data[:age] || 40)- 40)**2 +
    1*((self.data[:oxygen_saturation] || 90) - 90)**2
  end

  # validate if which one required other should be blank
  MAX_HEART_RATE = 500
  def validate_heart_rate
    if data["heart_rate"].nil? || !data["heart_rate"].empty?
      heart_rate = data["heart_rate"].to_i
      errors.add(:heart_rate, "must be a whole number between 0 and #{MAX_HEART_RATE}") if !heart_rate.between?(0, MAX_HEART_RATE) or !heart_rate.is_a? Integer
    else
      errors.add(:heart_rate, 'not present')
    end
  end

  MAX_RESPETORY_RATE=100
  # validate if which one required other should be blank
  def validate_respiratory_rate
    if data["respiratory_rate"].nil? || !data["respiratory_rate"].empty?
      respiratory_rate = data["respiratory_rate"].to_i
      errors.add(:respiratory_rate, "must be a whole number between 0 and #{MAX_RESPETORY_RATE}") if !respiratory_rate.between?(0, MAX_RESPETORY_RATE) or !respiratory_rate.is_a? Integer
    else
      errors.add(:respiratory_rate, 'not present')
    end
  end

  MAX_BODY_TEMP=50
  # validate if which one required other should be blank
  def validate_body_temp
    if data["body_temp"].nil? || !data["body_temp"].empty?
      body_temp = data["body_temp"].to_i
      errors.add(:body_temp, "must be a whole number between 0 and #{MAX_BODY_TEMP}") if !body_temp.between?(0, MAX_BODY_TEMP) or !body_temp.is_a? Integer
    else
      errors.add(:body_temp, 'not present')
    end
  end

  MAX_AGE=150
  def validate_age
    if data["age"].nil? || !data["age"].empty?
      age = data["age"].to_i
      errors.add(:age, "must be a whole number between 0 and #{MAX_AGE}") if !age.between?(0, MAX_AGE) or !age.is_a? Integer
    else
      errors.add(:age, 'not present')
    end
  end

  MAX_OXYGEN_SATURATION=100
  def validate_oxygen_saturation
    if data["oxygen_saturation"].nil? || !data["oxygen_saturation"].empty?
      oxygen_saturation = data["oxygen_saturation"].to_i
      errors.add(:oxygen_saturation, "must be a whole number between 0 and #{MAX_OXYGEN_SATURATION}") if !oxygen_saturation.between?(0, MAX_OXYGEN_SATURATION) or !oxygen_saturation.is_a? Integer
    else
      errors.add(:oxygen_saturation, 'not present')
    end
  end
end
