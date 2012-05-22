namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
		make_users
		make_companies
		make_projects
  end
end

def make_users
	admin = User.create!(name: "admin",
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

	def make_companies
		10.times do |n|
			slug = "fake-slug-#{n}"
			name = "fake-name-#{n}"
			Company.create slug: slug, name: name
		end
	end

	def make_projects 
		users = Users.all limit: 3
		companies = Companies.all limit: 10
		6.times do |n|
			name = "fake-project-#{n}"
			ptype = n%2+1
			location = "fake-location-#{n}"

			project = user[n%3].projects.build name: name, ptype: ptype, location: location
			company=(companies[10%n])
			project.save
		end 
		
	end

end
