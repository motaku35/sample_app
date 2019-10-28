require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'#ページを移動
    assert_select 'title', full_title(@user.name)#ページタイトルのテスト
    assert_select 'h1', text: @user.name#ユーザ名のテスト
    assert_select 'h1>img.gravatar'#h1タグの内側にあるgravatarクラス付きのimgタグがあるかどうかのテスト
    assert_match @user.microposts.count.to_s, response.body#micropostの数をmatch
    assert_select 'div.pagination', count:1#divタグのpaginationをテスト
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body#micropostの内text文がhtml内にあるかテスト
    end
    assert_match @user.microposts.count.to_s, @response.body
    assert_match @user.active_relationships.count.to_s, response.body
    assert_match @user.passive_relationships.count.to_s, response.body
  end
end
