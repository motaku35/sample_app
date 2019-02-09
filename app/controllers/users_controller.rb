class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # 保存の成功をここで扱う。
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user #ユーザのプロフィールページにリダイレクト
    else
      render 'new'
    end
  end

  private #外部ユーザーが使えないようにするための宣言

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
