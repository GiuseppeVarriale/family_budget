FactoryBot.define do
  factory :profile do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    association :user

    trait :with_avatar do
      after(:build) do |profile|
        profile.avatar.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'avatar.png')),
          filename: 'avatar.png',
          content_type: 'image/png'
        )
      end
    end
  end
end
