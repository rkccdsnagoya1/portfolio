require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require 'sinatra/json'
require './models/contribution.rb'
require './image_uploader.rb'

get '/' do
    @contents = Contribution.order('id desc').all
    erb :pt
end

get '/content' do
    @contents= Contribution.order('id desc').all
    erb :index
end


post '/new' do
    Contribution.create({
        body: params[:body],
        img: ""
    })
    if params[:file]
        image_upload(params[:file])
    end
        
    redirect '/content'
end

post '/delete/:id' do
    Contribution.find(params[:id]).destroy
    
    redirect '/content'
end
    
post '/edit/:id' do
    @content = Contribution.find(params[:id])
    erb :edit
end

post '/renew/:id' do
    @content = Contribution.find(params[:id])
    @content.update({
    name: params[:name],
    body: params[:body]
  })
  redirect '/content'
end