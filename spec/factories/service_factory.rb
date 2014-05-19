FactoryGirl.define do
  factory :service do
    sequence(:name) { ('a'..'z').to_a.shuffle.slice(0..10).join }
    sequence(:price) { (1..30).to_a.shuffle[0] }
    sequence(:duration) { (1..50).to_a.shuffle[0] }
    sequence(:discount) { (1..20).to_a.shuffle[0] }
  end
end