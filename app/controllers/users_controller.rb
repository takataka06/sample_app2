class UsersController < ApplicationController
  def new
    @user = User.new
  end
  def show
    @user = User.find(params[:id])
  end
  def edit
    @user = User.find(params[:id])
  end
  def create
    @user = User.new(user_params)   
    if @user.save
      reset_session # ログインの直前に必ずこれを書くこと
      # ユーザーが保存された後にセッションをリセットする
      # これにより、セッションのIDが変更され、セキュリティが向上する
      log_in @user
      # 保存の成功をここで扱う。
      flash[:success] = "Welcome to the Sample App!" # メッセージを追加
      redirect_to @user # showアクションにリダイレクト
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
    else
      render 'edit', status: :unprocessable_entity
    end
  end
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
