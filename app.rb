require 'sinatra'
require 'sinatra/activerecord'
require './models/user.rb'
require 'bundler/setup'          # ensures you're loading gems defined in the gemfile
require 'sinatra/flash'             # loads sinatra flash

set :database, 'sqlite3:nycda_831.sqlite3'
configure(:development){set :database, "sqlite3:blog.sqlite3"}
enable :sessions


get '/' do
    erb :layout
end

get '/register' do
    erb :register
end

post '/create' do
    if params[:user][:password] != params[:confirm_password]
        flash[:error] = "Passwords do not match!"
        redirect '/register'
        return
    end

    User.create(params[:user])

    redirect '/'
end


post '/sign-in' do 

    @user = User.where(email: params[:email]).first 
    
    if @user && @user.password == params[:password]
        session[:user_id] = @user.id      # you'll know which user is signed in based off of session[:user_id]
        flash[:success] = "You have been signed-in!!"
        redirect '/signed_in'
    else
        flash[:error] = "Incorrect email or password!!"
        
    end
end

get '/sign-out' do 
    'signed out'
end



get '/signed_in' do
      
    puts session.inspect
    if session[:user_id]
        $user = current_user
    else
        redirect '/'
        
    end
    erb :signed_in
end

# This function will return a User object if a user is signed in and will return nil if no user is signed in
def current_user 
    if session[:user_id]
        User.find(session[:user_id])
    end
end
