class ChangeCompanyRenameEmailSufixToEmailSuffix < ActiveRecord::Migration[6.1]
  def change
    rename_column :companies, :email_sufix, :email_suffix
  end
end
