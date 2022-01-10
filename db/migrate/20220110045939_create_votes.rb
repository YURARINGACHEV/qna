class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.references :user, foreign_key: true
      t.references :votable, polymorphic: true
      t.integer :value, default: 0

      t.timestamps
    end
  end
end
