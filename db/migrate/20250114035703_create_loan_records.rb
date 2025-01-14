class CreateLoanRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :loan_records do |t|
      t.string :account
      t.string :categories
      t.decimal :orig_bal
      t.jsonb :data

      t.timestamps
    end
  end
end
