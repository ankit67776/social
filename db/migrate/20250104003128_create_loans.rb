class CreateLoans < ActiveRecord::Migration[8.0]
  def change
    create_table :loans do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :loan_application, null: false, foreign_key: true
      t.text :details

      t.timestamps
    end
  end
end
