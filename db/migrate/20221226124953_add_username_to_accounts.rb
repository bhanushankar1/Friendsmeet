class AddUsernameToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :first_name, :string, limit: 20
    add_column :accounts, :last_name, :string, limit: 20
    add_column :accounts, :username, :string, limit: 20
    add_column :accounts, :user_type, :integer, default: 2


  end
end


