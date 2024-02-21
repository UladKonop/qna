class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.integer :value
      t.references :votable, polymorphic: true, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
