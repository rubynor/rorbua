class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reports do |t|
      t.text :description
      t.integer :status
      t.references :reportable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
