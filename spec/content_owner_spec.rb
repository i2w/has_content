require 'spec_helper'
require 'owner_shared'

describe ContentOwner do
  let(:owner) { described_class.new }
  let(:content_name) { :body }
  
  it_should_behave_like "new owner with has_content"  
  
  its(:content_names) { should == ['body', 'excerpt', 'sidebar'] }
  
  its(:content_association_names) { should == ['body_content', 'excerpt_content', 'sidebar_content'] }
  
  describe "subclass" do
    let(:klass) { Class.new(described_class) }
    let(:owner) { klass.new }
    
    it_should_behave_like "new owner with has_content"

    context 'after adding new content :thingo' do
      before(:all) do klass.has_content :thingo end
        
      its(:content_names) { should == ['body', 'excerpt', 'sidebar', 'thingo'] }

      its(:content_association_names) { should == ['body_content', 'excerpt_content', 'sidebar_content', 'thingo_content'] }
    end

    context 'when a content attribute is protected' do
      before(:all) do klass.attr_protected :excerpt end
        
      it 'setting via attributes fails' do
        owner.attributes = {excerpt: 'foo', body: 'bar'}
        owner.excerpt.should be_nil
        owner.body.should == 'bar'
        owner.save
        owner.reload.body_content.content.should == 'bar'
        owner.reload.excerpt_content.content.should be_nil
      end
    end
  end
end