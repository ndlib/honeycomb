require 'spec_helper'

describe Masquerade do

  before(:each) do
    @controller = double(ActionController, :session => {}, :current_user => double(User, id: 1) )
    @controller.stub(:sign_in)
  end

  describe :start! do
    before(:each) do
      Masquerade.any_instance.stub(:find_or_create_user).and_return(double(User, :username => 'username', name: 'bob bobbers'))
    end

    it "calls sign in on the controller" do
      @controller.should_receive(:sign_in)
      Masquerade.new(@controller).start!('username')
    end

    it "sets a session value so we can return to the original user" do
      Masquerade.new(@controller).start!('username')
      @controller.session[:masquerading].should == 1
    end

    it "sets the masqueading user correctly " do
      # this test and code exists becaues @controller.sign_in does not always return the new user's name on the first page load
      m = Masquerade.new(@controller)
      m.start!('username')

      m.masquerading_user.name.should == 'bob bobbers'
    end

  end

  describe :stop! do
    before(:each) do
      @user = double(User, :name => 'Original User')
      Masquerade.any_instance.stub(:original_user).and_return(@user)
      Masquerade.any_instance.stub(:masquerading?).and_return(true)
    end

    it "calls sign in on the controller with the original user" do
      @controller.should_receive(:sign_in).with(@user)

      Masquerade.new(@controller).cancel!
    end


    it "empties the session out" do
      @controller.should_receive(:sign_in).with(@user)

      Masquerade.new(@controller).cancel!

      @controller.session[:masquerading].should == false
    end
  end

end
