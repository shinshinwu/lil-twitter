class CreateTweets < ActiveRecord::Migration

  def change
    create_table :tweets do |t|
      t.string :content
      t.belongs_to :user
      t.integer :retweet_count, default: 0

      t.timestamps
    end
  end
end
