class CreateRetweets < ActiveRecord::Migration
  def change
    create_table :retweets do |t|
      t.belongs_to :tweet

      t.integer :original_user_id
      t.integer :retweet_user_id

      t.timestamps
    end
  end
end
