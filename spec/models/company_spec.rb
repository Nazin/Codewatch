# == Schema Information
#
# Table name: companies
#
#	 id		:integer				 not null, primary key
#	 name :string(32)			 not null
#	 slug :string(255)		 not null
#

require 'spec_helper'

describe Company do
	
	#TODO moar tests

	before { @company = Company.new name: "HP", slug: "hp" }

	subject { @company }
	it { should respond_to :projects }

end
