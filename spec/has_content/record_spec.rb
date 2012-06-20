require 'spec_helper'

describe HasContent::Record do
  subject { record }

  let(:record) { described_class.new }
  
  describe 'with valid attributes' do
    before do
      record.name = 'body'
      record.owner = owner
    end
    
    let(:owner) { ContentOwner.create! }
    
    it { should be_valid }
    
    describe '[validation]' do
      it 'requires :name' do
        subject.name = nil
        should_not be_valid
      end
    
      it 'requires :name + :owner be unique' do
        record.save!
        record = described_class.new {|r| r.name = 'body'; r.owner = owner }
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
