require 'spec_helper'

describe HasContent::Record do
  describe 'starting with valid attributes' do
    subject       { record }
    
    let(:record)  { described_class.new :name => 'body', :owner =>  owner }
    let(:owner)   { ContentOwner.create! }
    
    it { should be_valid }
    
    it 'requires :owner' do
      subject.owner = nil
      should_not be_valid
    end
    
    it 'requires :name' do
      subject.name = nil
      should_not be_valid
    end
    
    it 'requires :name + :owner be unique' do
      record.save!
      record = described_class.new :name => 'body', :owner => owner
      record.should_not be_valid
      record.name = 'boody'
      record.should be_valid
      record.name = 'body'
      record.owner = ContentOwner.create!
      record.should be_valid
    end
    
    describe 'requires :name be in a format suitable for a simple accessor method' do
      ['foo bar', '123bar', 'foo!', 'foo=', 'foo-bar', 'foo+bar'].each do |invalid|
        context invalid do
          before { record.name = invalid }
          it { should_not be_valid}
        end
      end

      ['_foo', 'foo_bar', 'a123bar', 'foo', 'FooBar'].each do |valid|
        context valid do
          before { record.name = valid }
          it { should be_valid}
        end
      end
    end
  end
end
