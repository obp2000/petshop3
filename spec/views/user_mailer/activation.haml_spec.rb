require 'spec_helper'

describe "user_mailer/activation" do

  before do
    assign( :user, @user = users_proxy.first )
  end
  
  it "creates user activation letter" do
    render
    rendered.should contain( @user.login )
    rendered.should contain( url_for( :host => 'localhost:3001', :controller => "sessions",  :action => "create",
          :user => @user.login, :password => @user.password )  )
  end

end
