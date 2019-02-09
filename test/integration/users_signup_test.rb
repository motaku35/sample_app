require 'test_helper'

#新規ユーザー用の統合テスト
class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  #無効なユーザ登録に対してのテスト
  test "invalid signup information" do
    get signup_path #ユーザー登録ページにアクセス
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new' #newテンプレートが実行されている時にtrue
    assert_select 'div.alert'#アクションの実行の結果として描写されるHTMLの内容を検証
    assert_select 'div#error_explanation'#アクションの実行の結果として描写されるHTMLの内容を検証
    assert_select 'form[action="/signup"]'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
  end
end
