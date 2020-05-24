FactoryBot.define do
  factory :transaction do
    uuid { "" }
    amount { "9.99" }
    status { 1 }
    customer_email { "MyString" }
    customer_phone { "MyString" }
  end
end
