namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
		make_users
		make_companies
		make_roles
		make_projects
		make_tasks_for_admin
  end
end


def make_tasks_for_admin
	admin = User.find_by_mail "admin@codewatch.pl"
	project = admin.companies.find_by_id(2).projects.find_by_id 6
	10.times do |n|
		title = "task #{n}"
		description = "descr"
		posted = 1.day.ago
		state = 1
		priority = 1
		deadline  = 1.day.from_now
		task = Task.new priority: 1, title: title, description: description, state: state, deadline: deadline
		task.posted= 0.days.from_now
		task.user = admin
		task.responsible_user = admin
		task.project = project
		task.save
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
		p.users << u
		p.save!
	end
	
end
