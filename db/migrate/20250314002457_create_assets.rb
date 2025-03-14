class CreateAssets < ActiveRecord::Migration[8.0]
  def change
    create_table :assets do |t|
      t.references :site, null: false, foreign_key: true
      t.string :path

      t.timestamps
    end
  end
end
