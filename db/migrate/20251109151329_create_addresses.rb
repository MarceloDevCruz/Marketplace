class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.string :street, null: false, default: ""
      t.string :city, null: false, default: ""
      t.string :state, null: false, default: ""
      t.string :zip_code, null: false, default: ""
      t.string :neighborhood, null: false, default: ""
      t.string :number, null: false, default: ""
      t.string :complement, default: ""
      t.timestamps
    end
  end
end
