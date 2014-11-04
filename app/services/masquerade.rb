class Masquerade


  def initialize(controller)
    @controller = controller
  end


  def start!(username)

    begin
      user = find_or_create_user(username)
      if !user
        return false
      end
    rescue User::APIException
      return false
    end

    @controller.session[:masquerading] = @controller.current_user.id
    @controller.sign_in(user)
    @masquerading_user = user

    return true
  end


  def cancel!
    if masquerading?
      @controller.sign_in(original_user)
      @controller.session[:masquerading] = false
    end
  end


  def masquerading?
    @controller.session[:masquerading]
  end


  def masquerading_user
    if masquerading?
      @masquerading_user ||= @controller.current_user
    else
      nil
    end
  end


  def original_user
    if masquerading?
      @original_user ||= User.find(@controller.session[:masquerading])
    else
      @original_user ||= @controller.current_user
    end
  end


  private

    def find_or_create_user(username)
      begin
        u = User.where(:username => username).first

        if !u
          u = User.new(:username => username)
          u.send(:fetch_attributes_from_api)
          u.save!
        end

        u
      rescue ActiveRecord::RecordInvalid
        false
      end
    end


end
