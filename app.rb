# Gemfileで導入したものを利用
require 'rubygems'
require 'bundler'
Bundler.require

# DB設定(adapter->接続するDBの種類,database->DB名)
set :database, {adapter: "sqlite3", database: "contacts.sqlite3"}

#sessionを有効化(sinatra)
enable :sessions

# DBのテーブル名が「contacts」なのでActiveRecordのインスタンス名は「Contact」(頭文字->大文字、_->大文字、s->削除)
class Contact < ActiveRecord::Base
  # [意味]「nameは必ず必要」みたいなチェック
  validates_presence_of :name
  validates_presence_of :email
end

get "/" do
    #(DBの)テーブルデータを取得
    @contact_lists = Contact.all
    @message = session[:name]
    session.delete(:name) # 1度だけ追加messageを表示するので、表示後削除
    @delete_message = session[:deleteMessage]
    session.delete(:deleteMessage)
    erb :index
end

# =====新規追加画面遷移
get "/contact_new" do
    @contact = Contact.new
    erb :add
end

# =====追加した連絡先を削除
get "/contact_delete" do
    contact_id = params[:id]
    contact_name = params[:name]
    @contact_delete = Contact.find(contact_id).destroy
    if @contact_delete
        session[:deleteMessage] = "#{contact_name}さんの連絡先削除が成功しました！"
    end
    redirect '/'
end

# =====新規データをDBへ追加＆追加メッセージ格納
post '/add_contacts' do
    name = params[:name]
    email = params[:email]
    #DBへ保存
    @contact = Contact.new({name: name, email: email})
    if @contact.save
        #nameをsessionに保存
        session[:name] = "#{name}さんの連絡先を追加しました。"
        redirect '/' # '/'を呼ぶだけの処理
    else
        erb :add
    end
end