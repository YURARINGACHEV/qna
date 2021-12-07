FactoryBot.define do
  sequence :body do |n|
    "Answer body #{n}"
  end

  factory :answer do
    body
    question

    trait :files do
      after(:build) do |answer|
        answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      end
    end

    trait :invalid do
      body { nil }
      question
    end
  end
end
