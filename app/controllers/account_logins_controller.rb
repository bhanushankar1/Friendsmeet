class AccountLoginsController < Devise::SessionsController
  
    def destroy
      acc = Account.find (current_account.id)
      acc.current_sign_in_at = nil
      acc.save
      super do
        return redirect_to after_sign_out_path_for(resource_name), status: :see_other
      end
    end
  
end