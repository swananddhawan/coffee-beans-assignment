class CreatePublishedEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :published_events, id: :uuid do |t|
      t.references :event, type: :uuid, foreign_key: true
      t.string :platform, null: false
      t.datetime :published_at
      t.jsonb :api_responses, default: []

      t.timestamps
    end

    add_index :published_events, [:event_id, :platform], unique: true
  end
end
