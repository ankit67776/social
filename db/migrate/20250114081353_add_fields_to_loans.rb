class AddFieldsToLoans < ActiveRecord::Migration[8.0]
  def change
    add_column :loans, :account, :string
    add_column :loans, :categories, :string
    add_column :loans, :orig_bal, :decimal
    add_column :loans, :loan_history, :jsonb # Include loan history
    add_column :loans, :data, :jsonb
  end
end
