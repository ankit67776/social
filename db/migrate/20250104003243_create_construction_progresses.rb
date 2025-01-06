class CreateConstructionProgresses < ActiveRecord::Migration[8.0]
  def change
    create_table :construction_progresses do |t|
      t.references :property, null: false, foreign_key: true
      t.text :details

      t.timestamps
    end
  end
end
