require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "login with invalid information" do #無効なログイン情報でログインしたときの挙動
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_response :unprocessable_entity #HTTPステータス422で返ってくるかチェック
    assert_template 'sessions/new'
    assert_not flash.empty? #フラッシュメッセージが空でないことを確認
    get root_path
    assert flash.empty?
  end
end
