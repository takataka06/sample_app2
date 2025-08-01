require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:michael)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "Account activation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["user@realdomain.com"], mail.from
    assert_match user.name,               mail.body.encoded # ユーザー名が含まれていることを確認
    assert_match user.activation_token,   mail.body.encoded # アクティベーショントークンが含まれていることを確認
    assert_match CGI.escape(user.email),  mail.body.encoded # エスケープされたメールアドレスが含まれていることを確認
  end #正規表現と文字列の一致をmatchメソッドで確認


  test "password_reset" do
    user = users(:michael)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal "Password reset", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["user@realdomain.com"], mail.from
    assert_match user.reset_token,        mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded
  end

end
