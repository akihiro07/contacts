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
    @current_time = Time.now
    #(DBの)テーブルデータを取得
    @contact_lists = Contact.all
    @message = session[:name]
    # 1度だけ追加messageを表示するので、表示後削除
    session.delete(:name)
    erb :index
end

get "/contact_new" do
    @contact = Contact.new
    erb :add
end

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