class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper #セッション用ヘルパーの読み込み、継承によりどのコントローラでも使用可能になる
end
