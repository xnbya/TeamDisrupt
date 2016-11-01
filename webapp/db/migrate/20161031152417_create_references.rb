class CreateReferences < ActiveRecord::Migration[5.0]
  def change
    create_table :references do |t|
      t.string :title, default: ""
      t.string :link, null: false
      t.string :note, default: ""

      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
