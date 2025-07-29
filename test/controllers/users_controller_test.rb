require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end
  

  test "should redirect edit when logged in as wrong user" do # 他のユーザーの編集ページにアクセスできないことを確認
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url # root_urlにリダイレクトされることを確認
  end

  test "should redirect update when logged in as wrong user" do # 他のユーザーの更新を試みた場合、リダイレクトされることを確認
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end
  test "should get new" do
    get signup_path
    assert_response :success
  end
end
