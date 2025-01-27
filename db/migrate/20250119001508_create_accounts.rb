class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.string :account
      t.string :principal_balance
      t.string :interest_rate
      t.string :maturity_date

      t.timestamps
    end
  end
end
