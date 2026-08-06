class AddCompanyAndSalaryToJobPostings < ActiveRecord::Migration[8.0]
  def change
    add_reference :job_postings, :company, foreign_key: { on_delete: :nullify }
    add_column :job_postings, :min_salary, :integer, default: 140000
    add_column :job_postings, :max_salary, :integer, default: 220000
    add_column :job_postings, :currency, :string, default: "USD"
  end
end
