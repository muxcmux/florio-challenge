class CreatePatients < ActiveRecord::Migration[8.0]
  def change
    create_table :patients do |t|
      t.text :key, index: {unique: true}
      t.text :secret
      t.integer :schedule_days, default: 3

      t.timestamps
    end
  end
end
