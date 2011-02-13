require 'spec_helper'

describe "users/new" do

  before do
    assign( :user, @user = users_proxy.first.as_new_record )
  end
  
  it "renders new user form" do
    render
    rendered.should have_selector("form#new_user", :method => "post", :action => users_path ) do |form|
      form.should have_text_field( @user, "login" )
      form.should have_text_field( @user, "email" )
      form.should have_text_field( @user, "last_name" )
      form.should have_text_field( @user, "first_name" )
      form.should have_password_field( @user, "password" )
      form.should have_password_field( @user, "password_confirmation" )        
      form.should have_selector( "input", :type => "submit" )
    end
  end

end
