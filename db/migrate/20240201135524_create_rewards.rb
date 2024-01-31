class CreateRewards < ActiveRecord::Migration[6.1]
  def change
    create_table :rewards do |t|
      t.string :title
      t.string :question_title
      t.belongs_to :rewardable, polymorphic: true

      t.timestamps
    end
  end
end
