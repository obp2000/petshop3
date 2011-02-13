require 'spec_helper'

describe "user_mailer/forgot_password" do

  before do
    assign( :user, @user = users_proxy.first )
  end
  
  it "creates user password reset letter" do
    render
    rendered.should contain( @user.login )
    rendered.should contain( url_for( :host => 'localhost:3001', :controller => "sessions",
          :action => "reset_password", :id => @user.pw_reset_code) )
  end

end
