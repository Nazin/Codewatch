class UserMailer < ActionMailer::Base
	
	default from: "no-reply@codewatch.pl"
	
	def activate_email user, key
		
		@user = user
		@url = url_for :controller => 'users', :action => 'activate', :key => key
		
		mail(:to => "#{@user.name} <#{@user.mail}>", :subject => "Account activation @ codewatch.pl")
	end
	
	def welcome_email user
		
		@user = user
		@url = url_for :controller => 'users', :action => 'signin', :host => user.companies[0].slug + '.' + ActionMailer::Base.default_url_options[:host]
		
		mail(:to => "#{@user.name} <#{@user.mail}>", :subject => "Welcome @ codewatch.pl")
	end
	
	def invite_email to, company, key
		
		@company = company
		@url = url_for :controller => 'users', :action => 'signup', :key => key
		
		mail(:to => to, :subject => "Invitation @ codewatch.pl")
	end
end
