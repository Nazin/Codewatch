# == Schema Information
#
# Table name: milestones
#
#  id         :integer         not null, primary key
#  name       :string(32)      not null
#  deadline   :datetime
#  project_id :integer         not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Milestone do
  let(:project) { FactoryGirl.create :project }

  before do
    @milestone = project.milestones.build name: "milestone", deadline: 1.week.ago
    @milestone.save!
  end

  subject { @milestone }

  it { should be_valid }

  describe "assocations" do
    it { should respond_to :project }
    it { should respond_to :tasks }
  end

  it { should respond_to :name }
  it { should respond_to :deadline }

  describe "name" do
    describe "when nil" do
      before { @milestone.name = nil }
      it { should_not be_valid }
    end
    describe "when empty" do
      before { @milestone.name = "" }
      it { should_not be_valid }
    end
    describe "when too long" do
      before { @milestone.name = "a"*33 }
      it { should_not be_valid }
    end
  end
end
