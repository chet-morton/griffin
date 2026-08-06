class CreateCompanies < ActiveRecord::Migration[8.0]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :industry, null: false, default: "Technology"
      t.string :website
      t.string :tier, null: false, default: "Enterprise"
      t.decimal :hiring_velocity_score, precision: 4, scale: 2, default: 85.0
      t.text :notes
      t.text :ai_summary

      t.timestamps
    end

    add_index :companies, :name, unique: true
    add_index :companies, :tier
  end
end
