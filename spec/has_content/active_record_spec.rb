require 'spec_helper'

describe HasContent::ActiveRecord do
  subject { content_owner }
  let(:content_owner) { Class.new(ActiveRecord::Base) }
  
  describe '.has_content(name)' do
    subject { content_owner.has_content(name) }
    
    describe 'requires name be in a format suitable for a simple accessor method' do
      ['foo bar', '123bar', 'foo!', 'foo=', 'foo-bar', 'foo+bar'].each do |invalid|
        context invalid.inspect do
          let(:name) { invalid }
          it { expect { subject }.to raise_error ArgumentError }
        end
      end

      ['_foo', 'foo_bar', 'a123bar', 'foo', 'FooBar'].each do |valid|
        context valid.inspect do
          let(:name) { valid }
          it { expect { subject }.to_not raise_error }
        end
      end
    end
  end
  
  it '.has_content() raises ArgumentError' do
    expect{ content_owner.has_content }.to raise_error(ArgumentError)
  end 
  
  it '.has_content(<extsiting name>) raises ArgumentError' do
    content_owner.has_content(:foo)
    expect{ content_owner.has_content(:foo) }.to raise_error(ArgumentError)
  end
end
