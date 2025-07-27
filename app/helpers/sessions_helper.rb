module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  # 現在ログイン中のユーザーを返す（いる場合）

  def current_user
    if session[:user_id]# セッションに user_id が入ってたら（＝ログインしてたら）、
      @current_user ||= User.find_by(id: session[:user_id])#そのIDをもとにユーザー情報をDBから探して返す。
      #しかも、一度探したら次回以降はキャッシュした値を再利用する。@current_user で呼び出すときは、毎回DBを参照しないから
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end

  # 現在のユーザーをログアウトする
  def log_out
    reset_session
    @current_user = nil   # 安全のため
  end
end
