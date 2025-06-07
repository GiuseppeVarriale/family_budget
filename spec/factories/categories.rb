FactoryBot.define do
  factory :category do
    name { 'Test Category' }
    description { 'Test Category' }
    category_type { :expense }

    trait :income do
      category_type { :income }
      name { 'Salary' }
      description { 'Monthly salary income' }
    end

    trait :expense do
      category_type { :expense }
      name { 'Rent' }
      description { 'Monthly rent payment' }
    end
  end
end
