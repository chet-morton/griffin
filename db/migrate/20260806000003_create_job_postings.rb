class CreateJobPostings < ActiveRecord::Migration[8.0]
  def change
    create_table :job_postings do |t|
      t.string :title, null: false
      t.string :department, null: false
      t.text :description
      t.string :status, null: false, default: "draft"
      t.string :location, null: false, default: "Remote"

      t.timestamps
    end

    add_index :job_postings, :status
    add_index :job_postings, :department
  end
end
