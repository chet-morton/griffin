class CreateSkillRequirements < ActiveRecord::Migration[8.0]
  def change
    create_table :skill_requirements do |t|
      t.references :job_posting, null: false, foreign_key: { on_delete: :cascade }
      t.string :name, null: false
      t.decimal :weight, precision: 5, scale: 2, default: 1.0, null: false
      t.integer :minimum_score, default: 3, null: false
      t.text :rubric_description

      t.timestamps
    end

    add_index :skill_requirements, [:job_posting_id, :name], unique: true
  end
end
