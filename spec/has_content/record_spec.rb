require 'spec_helper'

describe HasContent::Record do
  subject { record }

  let(:record) { described_class.new attrs }
  let(:attrs)  { {} }
  
  it "does not save itself - as it's invalid" do
    should be_new_record
  end
  
  describe 'with valid attributes' do
    let(:attrs) { {:name => 'body', :owner => owner} }
    let(:owner) { ContentOwner.create! }
    
    it "saves itself (to enable always referring relationships)" do
      should_not be_new_record
    end
    
    it { should be_valid }
    
    describe '[validation]' do
      it 'requires :name' do
        subject.name = nil
        should_not be_valid
      end
    
      it 'requires :name + :owner be unique' do
        record.save!
        record = described_class.new :name => 'body', :owner => owner
        record.should_not be_valid
        record.name = 'excerpt'
        record.should be_valid
        record.name = 'body'
        record.owner = ContentOwner.create!
        record.should be_valid
      end
    
      it 'requires :name be one of owner\'s content_names' do
        record.name = 'not_there'
        record.should_not be_valid
      end
    end
  end
  
  describe '#to_s' do
    subject { record.to_s }
    
    it 'is the content attribute' do
      record.content = 'foo'
      subject.should == 'foo'
    end
  end
end
