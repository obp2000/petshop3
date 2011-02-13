require 'spec_helper'

describe "contacts/_show" do

  before do
#    assigns[ :object ] = contacts_proxy.first
    assign( :object, @contact = contacts_proxy.first )
  end
  
  it "renders contact information" do
    render
    rendered.should contain( @contact.name )
    rendered.should contain( @contact.email )   
    rendered.should contain( @contact.phone )
    rendered.should contain( @contact.icq )    
    rendered.should contain( @contact.address )
  end

end
