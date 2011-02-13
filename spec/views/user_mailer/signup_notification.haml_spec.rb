require 'spec_helper'

describe "user_mailer/signup_notification" do

  before do
    assign( :user, @user = users_proxy.first )
  end
  
  it "creates user signup notification letter" do
    render
    rendered.should contain( @user.login )
    rendered.should contain( @user.password )    
    rendered.should contain( url_for( :host => 'localhost:3001', :controller => "users",
          :action => "activate", :id => @user.activation_code) )
  end

end
