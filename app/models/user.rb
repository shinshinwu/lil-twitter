require 'bcrypt'

class User < ActiveRecord::Base
  has_many :followings
  has_many :tweets
  has_many :retweets

  include BCrypt

  validates :username, :presence => true,
                       :uniqueness => true
  validates :email,    :presence => true,
                       :uniqueness => true,
                       :format => { :with => /\w+@\w+\.\w+/ }
  validates :password, :presence => true

# works
  def follower
    follower_ids = []
    Following.where(follower_id: self.id).each {|follower| follower_ids << follower.following_id }
    follower_ids
  end

  def following
    following_ids = []
    Following.where(following_id: self.id).each {|follower| following_ids << follower.follower_id }
    following_ids << self.id
    following_ids
  end

  def following_latest_tweets


  end

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def self.authenticate(params)
    user = User.find_by(email: params[:email])
    (user && user.password == params[:password]) ? user : nil
  end

end
