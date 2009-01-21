class Users < Application

  def new
    @user = User.new
    display @user
  end

  def create(user)
    @user = User.new(user)
    if @user.save
      redirect resource(:characters), :message => {:notice => "User was successfully created"}
    else
      message[:error] = "User failed to be created"
      render :new
    end
  end

end