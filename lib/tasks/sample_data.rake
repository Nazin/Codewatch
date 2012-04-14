namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "Codewatch Admin",
                 mail: "admin@codewatch.pl",
                 password: "ala123",
                 password_confirmation: "ala123")
    admin.toggle! :admin
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
