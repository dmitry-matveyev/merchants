FactoryBot.define do
  factory :transaction do
    merchant
    uuid { SecureRandom.uuid }
    amount { "9.99" }
    status { Transaction.statuses[:approved] }
    customer_email { "MyString" }
    customer_phone { "MyString" }

    trait :authorized do
      type { Transaction::Authorized.name }
    end

    trait :charged do
      type { Transaction::Charged.name }
    end
  end
end
