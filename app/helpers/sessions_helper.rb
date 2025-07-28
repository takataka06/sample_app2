module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  # 現在ログイン中のユーザーを返す（いる場合）

  def current_user
    if (user_id = session[:user_id])#（ユーザーIDにユーザーIDのセッションを代入した結果）ユーザーIDのセッションが存在すれば
      @current_user ||= User.find_by(id: user_id) # session[:user_id] が存在する場合、@current_user を設定し、User.find_by(id: user_id) でユーザーを取得
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  #ユーザーIDと記憶トークンの永続cookiesを作成します
  def remember(user)
    user.remember # remember メソッドを呼び出して、remember_token を生成し、remember_digest を更新する。
    cookies.permanent.encrypted[:user_id] = user.id 
    cookies.permanent[:remember_token] = user.remember_token
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user) 
    reset_session
    @current_user = nil   # 安全のため
  end
  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
end
