# This will guess the User class
FactoryBot.define do
  factory :patient do
    predicted_time { Faker::Time.between(DateTime.now, DateTime.now + 3.hours) }
    phone_number { Faker::PhoneNumber.cell_phone }
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    aasm_state { ['waiting', 'canceled', 'notified'].sample }
  end
end
