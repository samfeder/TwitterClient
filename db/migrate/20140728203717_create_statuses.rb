class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :body
      t.string :twitter_status_id
      t.string :twitter_user_id

      t.timestamps
    end

    add_index(:statuses, :twitter_status_id)
    add_index(:statuses, :twitter_user_id)
  end
end
