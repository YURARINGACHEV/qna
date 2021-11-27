FactoryBot.define do
  factory :answer do
    body { 'MyText_answer' }
    question

    trait :invalid do
      body { nil }
      question
    end
  end
end
