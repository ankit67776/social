class CreateLoanHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :loan_histories do |t|
      t.references :loan, null: false, foreign_key: true
      t.decimal :loan_balance, precision: 10, scale: 2
      t.text :notes
      t.datetime :paid_to
      t.string :source_app
      t.decimal :total_amount, precision: 10, scale: 2

      t.timestamps
    end
  end
end
