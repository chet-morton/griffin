class EnablePgvectorExtension < ActiveRecord::Migration[8.0]
  def change
    if ActiveRecord::Base.connection.adapter_name.downcase.include?("postgresql")
      enable_extension "vector" unless extension_enabled?("vector")
    end
  end
end
