FactoryBot.define do
  factory :category do
    description { 'Test Category' }
    category_type { :expense }

    trait :income do
      category_type { :income }
      description { 'Salary' }
    end

    trait :expense do
      category_type { :expense }
      description { 'Rent' }
    end
  end
end
