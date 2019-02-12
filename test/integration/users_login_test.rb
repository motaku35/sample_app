require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:michael)
  end

  test "login with invalid information" do
    get login_path #ログイン用のパスを開く
    assert_template 'sessions/new' #新しいセッションのフォームが正しく表示されたことを確認
    post login_path, params: { session: { email: "", password: "" } } #無効な引数でpost
    assert_template 'sessions/new' #新しいセッションが再表示
    assert_not flash.empty? #フラッシュメッセージの存在確認
    get root_path #homeに移動
    assert flash.empty? #フラッシュメッセージがないことを確認
  end

  test "login with valid information" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert_redirected_to @user #リダイレクト先の検証
    follow_redirect! #ページに実際に移動
    assert_template 'users/show' #ページに移動できているかの確認
    assert_select "a[href=?]", login_path, count: 0 #一致するリンクが0かどうかを確かめる
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end

  #ユーザのログアウトのテスト
  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end
