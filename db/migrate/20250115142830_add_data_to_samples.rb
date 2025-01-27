class AddDataToSamples < ActiveRecord::Migration[8.0]
  def change
    add_column :samples, :data, :json
  end
end
