class AddStatusToJobs < ActiveRecord::Migration[6.1]
  def change
    add_column :jobs, :status, :integer, default: 10
  end
end
