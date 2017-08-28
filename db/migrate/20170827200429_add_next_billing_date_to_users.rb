class AddNextBillingDateToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :next_billing_date, :datetime
  end
end
