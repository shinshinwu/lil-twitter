require "faker"

User.all.each do |user|
  user.tweets << Tweet.create(content: Faker::Company.bs)
end
