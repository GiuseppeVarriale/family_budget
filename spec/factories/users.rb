FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password123' }
    password_confirmation { 'password123' }
    role { 'user' }

    after(:create) do |user|
      create(:profile, user: user)
    end

    trait :admin do
      role { 'admin' }
    end
  end
end
