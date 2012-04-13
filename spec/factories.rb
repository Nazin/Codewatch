FactoryGirl.define do
  factory :user do
    name     "Michael Hartl"
    mail    "michael@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
end
