class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t| #テーブル名:頭文字→小文字, 接続語→_, 最後尾→s付ける
      t.string :name
      t.string :email
    end
  end
end
