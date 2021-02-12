class CreateCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :cnpj
      t.string :email_sufix
      t.string :site
      t.string :country
      t.string :state
      t.string :city
      t.string :zip_code
      t.string :neighborhood
      t.string :logradouro

      t.timestamps
    end
  end
end
