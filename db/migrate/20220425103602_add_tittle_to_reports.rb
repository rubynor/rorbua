class AddTittleToReports < ActiveRecord::Migration[7.0]
  def change
    add_column :reports, :tittle, :integer
  end
end
