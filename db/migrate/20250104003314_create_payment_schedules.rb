class CreatePaymentSchedules < ActiveRecord::Migration[8.0]
  def change
    create_table :payment_schedules do |t|
      t.references :loan, null: false, foreign_key: true
      t.text :details

      t.timestamps
    end
  end
end
