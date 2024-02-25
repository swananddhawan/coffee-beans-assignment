class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events, id: :uuid do |t|
      t.string :name, null: false
      t.references :user, type: :uuid, foreign_key: true
      t.jsonb :other_fields, default: {}

      t.timestamps
    end

    add_index :events, :name
  end
end
