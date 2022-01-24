FactoryBot.define do
  factory :question do
    title { 'Title' }
    body { 'MyText' }
    user

    trait :question_files do
      after(:build) do |question|
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      end
    end

    trait :invalid do
      title { nil }
    end
  end
end
