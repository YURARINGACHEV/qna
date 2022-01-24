FactoryBot.define do
  factory :comment do
    sequence :body do |n|
      "MyTextComment#{n}"
    end

    user

    trait :invalid do
      body { nil }
    end
  end
end
