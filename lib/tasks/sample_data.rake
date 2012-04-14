namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "Example User",
                 mail: "example@codewatch.pl",
                 password: "foobar",
                 password_confirmation: "foobar")
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@codewatch.pl"
      password  = "password"
      User.create!(name: name,
                   mail: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end
