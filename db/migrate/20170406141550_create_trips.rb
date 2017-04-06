class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.belongs_to :user
      
      t.datetime :depart_time
      t.string :depart_time_zone
      t.datetime :return_time
      t.string :return_time_zone
      t.string :confirmation_number

      t.timestamps null: false
    end
  end
end
