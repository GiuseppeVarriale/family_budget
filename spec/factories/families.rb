FactoryBot.define do
  factory :family do
    name { 'Família Silva' }
    description { 'Uma família feliz' }
    association :user
  end
end
