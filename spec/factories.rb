FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:mail) { |n| "person_#{n}@codewatch.pl"}   
    password "foobar"
    password_confirmation "foobar"
  end
end
