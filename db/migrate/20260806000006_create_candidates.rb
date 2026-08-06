class CreateCandidates < ActiveRecord::Migration[8.0]
  def change
    create_table :candidates do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :portfolio_url
      t.text :resume_text
      
      if ActiveRecord::Base.connection.adapter_name.downcase.include?("postgresql")
        t.vector :embedding, limit: 1536
      else
        t.text :embedding
      end

      t.timestamps
    end

    add_index :candidates, :email, unique: true
  end
end
