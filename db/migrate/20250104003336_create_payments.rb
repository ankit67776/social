class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.references :loan, null: false, foreign_key: true
      t.text :details

      t.timestamps
    end
  end
end
