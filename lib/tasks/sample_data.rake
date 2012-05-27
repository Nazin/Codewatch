namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
		make_users
		make_companies
		make_roles
		make_projects
  end
end

def make_roles
	users = User.all
	coms = Company.all
	coms_size = coms.size
	users.each_with_index do |u,i|
		com_index = (i+1)%coms_size
		c = coms[com_index]
		uc = u.user_companies.build
		uc.role = 1
		uc.company = c
		uc.save
	end
		
end


def make_users
	admin = User.create!(name: "admin",
	                     mail: "admin@codewatch.pl",
	                     password: "ala123",
	                     password_confirmation: "ala123")
	admin.toggle! :admin
	admin.toggle! :isActive
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
		users = User.all limit: 3
		users.each do |u|
			c = u.companies[0]
			6.times do |n|
				name = "fake-project-#{n}"
				ptype = n%2+1
				location = "fake-location-#{n}"
				project_params = { name: name, ptype: ptype, location: location }
				associate_user_company_project u, c, project_params
			end
		end 
	end

private
	
	def associate_user_company_project u, c, project_params
		p = c.projects.build project_params
		u.projects << p
		p.save!
	end
	
end
