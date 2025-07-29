class SessionsController < ApplicationController
  def new
  end
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      forwarding_url = session[:forwarding_url] # リダイレクト先URLを取得
      reset_session      # ログインの直前に必ずこれを書くこと
      params[:session][:remember_me] == '1' ? remember(user) : forget(user) #checkされたら永続ログインそれ以外なら無効か
      log_in user
      redirect_to forwarding_url || user # リダイレクト先があればそこにリダイレクト、なければユーザーのページにリダイレクト
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
    else
      flash.now[:danger] = 'Invalid email/password combination' # 本当は正しくない
      # エラーメッセージを作成する
      render "new", status: :unprocessable_entity
    end
  end
  def destroy
    log_out if logged_in? # ログインしている場合はログアウトする
    redirect_to root_url, status: :see_other
  end
end
