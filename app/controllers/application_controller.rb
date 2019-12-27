class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper #親クラスにこのモジュールを読み込ませることで、どのコントローラでもヘルパーに定義したメソッドが使えるようになる
end
