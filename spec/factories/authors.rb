FactoryGirl.define do
  factory :author do
    name FFaker::Name.name
    phone FFaker::PhoneNumber.phone_number
  end
end
