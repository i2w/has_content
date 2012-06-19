# let(:owner)        { a content owner instance }
# let(:content_name) { the name of the content }
describe "HasContent::ContentOwner", :shared => true do
  it 'should be built on demand for #content reader' do
    owner.send(content_name)
    owner.instance_eval("@#{content_name}_content").should be_kind_of(HasHasContent::Content::HasContent::Content)
  end
  
  it 'should be built on demand for #content= writer' do
    owner.send("#{content_name}=", 'foo')
    owner.instance_eval("@#{content_name}_content").content.should == 'foo'
  end
  
  it "content should have name == content_name" do
    owner.send(content_name)
    owner.send("#{content_name}_content").name.should == content_name
  end
    
  it "after save and reload, should have content" do
    owner.send("#{content_name}=", "foo")
    owner.save!
    owner.class.find(owner.id).send(content_name).should == "foo"
  end
  
  it "should not load assoc on parent save, if assoc not already loaded" do
    owner.should_not_receive("#{content_name}_content")
    owner.save!
  end

  it "when owner is a new_record, should not create a content until save" do
    if owner.new_record?
      lambda { owner.send(content_name) }.should_not change(HasContent::Content, :count)
      lambda { owner.save }.should change(HasContent::Content, :count).by(1) 
    end
  end
  
  it 'when owner is not new_record, should not create a content until save'
    if !owner.new_record?
      lambda { owner.send(content_name) }.should_not change(HasContent::Content, :count)
      lambda { owner.save }.should change(HasContent::Content, :count).by(1)
    end
  end
  
  it 'should have content_attributes corresponding to contents' do
    owner.send("#{content_name}=", "Foo")
    owner.content_attributes[content_name].should == "Foo"
  end
  
  it "should allow setting content via attributes" do
    owner.update_attributes content_name => "Foo"
    owner.reload.send(content_name).should == "Foo"
  end
end