class AddIndexToUsersEmail < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :email, unique: true #データベースにおけるインデックスは、「検索を早くする仕組み（索引）」
                                           #usersテーブルのemailカラムにインデックスを追加するため、add_indexというRailsのメソッドを記述
                                           #これにunique: trueオプションを指定することでデータベースに一意性を強制することができる
  end
end
