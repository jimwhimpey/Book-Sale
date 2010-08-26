require 'rubygems'
require 'haml'
require 'sinatra'
require 'nokogiri'
require 'maruku'
require 'dm-core'
require 'dm-mysql-adapter'

# Make Sinatra work with .scss sass files
configure do
  # Default is xhtml, do not want!
  set :haml, {:format => :html5, :escape_html => false}
end

# While developing we don't want to keep restarting Sinatra
# Also setup the data mapper
configure :development do
  require "sinatra/reloader"
  DataMapper.setup(:default, {
    :adapter  => 'mysql',
    :host     => 'localhost',
    :username => 'root' ,
    :password => 'root',
    :database => 'booksale'})  
end

# Different database for production
configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3://booksale.db')
end

# ==========================================
# Model for books

class Book
  include DataMapper::Resource
  property :id, Integer, :serial=>true
  property :title, String
  property :author, String
  property :type, String
  property :condition, String
  property :price, Integer
  property :description, String
  property :photo, String
  property :sold, String
end

# ==========================================
# Home Page

get '/' do
  
  # Get all the books
  @books = repository(:default).adapter.select('SELECT * FROM books ORDER BY RAND()')
  
  # Render HAML template
  haml :home
  
end

# ==========================================
# Individual Page

get '/book/:id' do
  @book = Book.get(params[:id])
  haml :book
end