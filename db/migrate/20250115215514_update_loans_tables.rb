class UpdateLoansTables < ActiveRecord::Migration[8.0]
  def change
    remove_column :loans, :customer_id, :bigint
    remove_column :loans, :loan_application_id, :bigint
    remove_column :loans, :details, :text
    remove_column :loans, :orig_bal, :numeric
  end
end
