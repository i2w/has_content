shared_examples_for "new owner with has_content" do
  
  # set the following to use this shared spec:
  #
  # let(:owner)        { a content owner instance }
  # let(:content_name) { the name of the content }

  it 'should be built on demand for #content reader' do
    owner.send(content_name)
    owner.send("#{content_name}_content").should be_kind_of(HasContent::Record)
  end
  
  it 'should be built on demand for #content= writer' do
    owner.send("#{content_name}=", 'foo')
    owner.send("#{content_name}_content").content.should == 'foo'
  end
  
  it "content should have name == content_name" do
    owner.send(content_name)
    owner.send("#{content_name}_content").name.should == content_name.to_s
  end
    
  it "after save and reload, should have content" do
    owner.send("#{content_name}=", "foo")
    owner.save!
    owner.class.find(owner.id).send(content_name).should == "foo"
  end
  
  it 'should have content_attributes corresponding to contents' do
    owner.send("#{content_name}=", "Foo")
    owner.content_attributes[content_name.to_s].should == "Foo"
  end
  
  it "should allow setting content via attributes" do
    owner.update_attributes content_name => "Foo"
    owner.reload.send(content_name).should == "Foo"
  end
  
  context '[before being saved]' do
    it "should not create a content record until save" do
      lambda { owner.send(content_name) }.should_not change(HasContent::Record, :count)
      lambda { owner.save! }.should change(HasContent::Record, :count).by(1) 
    end

    describe "#<content_name>_association" do
      subject { owner.send "#{content_name}_record" }

      it { should be_a HasContent::Record }
      it { should_not be_persisted }
    end
  end
  
  context '[after being saved]' do
    before { owner.save! }
    
    it 'should create content record on access' do
      lambda { owner.send(content_name) }.should change(HasContent::Record, :count).by(1)
      lambda { owner.save! }.should_not change(HasContent::Record, :count)
    end

    describe "#<content_name>_association" do
      subject { owner.send "#{content_name}_record" }

      it { should be_persisted }
    end
  end
end