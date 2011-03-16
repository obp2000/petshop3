require 'spec_helper'

describe "contacts/_show" do

  before do
    @contact = contacts_proxy.first
    assign( :object, @contact )
  end
  
  it "renders contact information" do
    view.should_receive( :show_page_title_for ).with( @contact ).and_return( "Show page title" )
    render
    rendered.should contain( "Show page title" )    
    rendered.should contain( @contact.name )
    rendered.should contain( @contact.email )   
    rendered.should contain( @contact.phone )
    rendered.should contain( @contact.icq )    
    rendered.should contain( @contact.address )
  end

end
