FactoryBot.define do
  factory :transaction do
    amount { 100.00 }
    description { 'Transação de teste' }
    transaction_date { Date.current }
    status { :pending }
    is_recurring { false }
    is_approximate { false }
    notes { 'Notas da transação' }
    association :category
    association :family

    trait :pending do
      status { :pending }
    end

    trait :paid do
      status { :paid }
    end

    trait :cancelled do
      status { :cancelled }
    end

    trait :recurring do
      is_recurring { true }
      recurring_frequency { :monthly }
    end

    trait :approximate do
      is_approximate { true }
    end

    trait :income do
      association :category, factory: %i[category income]
    end

    trait :expense do
      association :category, factory: %i[category expense]
    end

    trait :weekly_recurring do
      is_recurring { true }
      recurring_frequency { :weekly }
    end

    trait :monthly_recurring do
      is_recurring { true }
      recurring_frequency { :monthly }
    end

    trait :quarterly_recurring do
      is_recurring { true }
      recurring_frequency { :quarterly }
    end

    trait :yearly_recurring do
      is_recurring { true }
      recurring_frequency { :yearly }
    end
  end
end
