class ApplicationController < ActionController::Base
	
	before_filter :check_company
	
	protect_from_forgery
	include SessionsHelper
	
	def mail(to, name, subject, messageText) #TODO jakies ladne templatki sciagac z plikow czy cos?
		
		require 'net/smtp'
		
		message = <<MESSAGE_END
From: Codewatch.pl <no-reply@codewatch.pl>
To: #{name} <#{to}>
MIME-Version: 1.0
Content-type: text/html
Subject: #{subject} @ codewatch.pl

#{messageText}
MESSAGE_END
		
		Net::SMTP.start('localhost', 25) do |smtp|
			smtp.send_message message, 'no-reply@codewatch.pl', [to]
		end
	end
	
	def check_company
		
		
		
	end
end
