FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| ('a'..'z').to_a.shuffle.slice(0..8).join.titleize }

    sequence(:email) { |n| "email_#{n}@example.com" }

    sequence(:password) { |n| (0..9).to_a.shuffle.join }
    
  end
end