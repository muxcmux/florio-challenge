FactoryBot.define do
  factory :injection do
    association :patient
    dose { rand(1..10) }
    lot_number { "123abc" }
    drug_name { "Aspirin" }
  end
end
