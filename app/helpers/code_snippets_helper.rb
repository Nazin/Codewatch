module CodeSnippetsHelper


	def sha1 code
    salt = random_string 5
		Digest::SHA1.hexdigest(salt + password + salt)
	end


	def random_string len
		newstring = ""
		chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
		1.upto len  { |i| newstring << chars[rand(chars.size-1)] }
		newstring
	end


end
