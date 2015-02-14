get '/' do
  erb :index
end


# ------------- SESSIONS --------------

# once a user has signed in they should be redirected to the session page with just their urls that have been stored

# shows sign in page if user isn't logged in
get '/sessions/new' do
  erb :index
end

# creates a new user in the database and sets a session
post '/sessions' do
  if user = User.authenticate(params[:user])
    session[:user_id] = user.id
    redirect "/sessions/#{user.id}"
  else
    erb :index
  end
end

# probably could be moved to the model
# redirects the user to home page with a timeline of
# people they follow
get '/sessions/:user_id' do
  @user = User.find(params[:user_id])
  @following = @user.following
  tweets = []
  @following.each do |user_id|
    tweets << User.find(user_id).tweets
    Retweet.where(retweet_user_id: user_id).each do |retweet|
      tweets << Tweet.find(retweet.tweet_id)
    end
  end
  tweets.flatten!
  @tweets = tweets.sort_by {|tweet| tweet.created_at}.reverse
  # make some tweets of the people they are following avaible for view
  erb :homepage
end

# another model maybe
# directs the user to their profile page with all of their own tweets
get "/sessions/:user_id/profile" do
  @user = User.find(params[:user_id])
  erb :profile
end

# Add the user from the user page they were on to their following list
post "/sessions/:user_id/profile" do
  Following.create(follower_id: params[:user_id], following_id: current_user.id)
  redirect "/sessions/#{params[:user_id]}/profile"
end

# route to view all the people that is following the user
get '/sessions/:user_id/followers' do
  @user = User.find(params[:user_id])
  erb :followers
end

# route to view all the people that the user is following
get '/sessions/:user_id/followings' do
  @user = User.find(params[:user_id])
  erb :followings
end

# process new tweets and saves them to the DB
post '/sessions/:user_id/tweets' do
  @new_tweet = Tweet.create(content: params[:content], user_id: params[:user_id])
  redirect "/sessions/#{params[:user_id]}"
end

# add retweeted tweets to retweet table and refresh view
post '/sessions/:user_id/tweets/:tweet_id' do
  Retweet.create(tweet_id: params[:tweet_id], original_user_id: Tweet.find(params[:tweet_id]).user.id, retweet_user_id: current_user.id)
  Tweet.find(params[:tweet_id]).retweet_count += 1
  redirect "/sessions/#{current_user.id}"
end

# deletes a tweet if the current user id is the same
# as the tweet's owner
delete "/sessions/:user_id/tweets/:tweet_id" do
  Tweet.destroy(params[:tweet_id])
  redirect "/sessions/#{params[:user_id]}/profile"
end

# signs out a user and detroys the session
delete '/sessions/:id' do
  session[:user_id] = nil
  redirect '/'
end


# ------------- USERS ---------------

# directs the user to the the index page to sign up
get '/users/new' do
  erb :index
end

# create new user and redirect to user homepage
post '/users' do
  user = User.create(params[:user])
  if user.save
    session[:user_id] = user.id
    redirect "/sessions/#{user.id}" # (need to implement user url page)
  else
    erb :index
  end
end






