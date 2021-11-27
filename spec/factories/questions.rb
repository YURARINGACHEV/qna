FactoryBot.define do
  factory :question do
    title { 'Title' }
    body { 'MyText' }

    trait :invalid do
      title { nil }
    end
  end
end
