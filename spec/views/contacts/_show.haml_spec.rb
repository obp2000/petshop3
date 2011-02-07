require 'spec_helper'

describe "contacts/_show" do

  before do
    assigns[ :object ] = contacts_proxy.first
  end
  
  it "renders contact information" do
    render
    rendered.should contain( assigns[ :object ].name )
    rendered.should contain( assigns[ :object ].email )   
    rendered.should contain( assigns[ :object ].phone )
    rendered.should contain( assigns[ :object ].icq )    
    rendered.should contain( assigns[ :object ].address )
  end

end
