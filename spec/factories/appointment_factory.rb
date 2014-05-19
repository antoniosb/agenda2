FactoryGirl.define do

  factory :appointment do
    association :user, strategy: :build
    association :service, strategy: :build
    appointment_date { Time.now }
  end
end