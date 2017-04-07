class CreateProxies < ActiveRecord::Migration
  def change
    create_table :proxies do |t|
      t.string :ip
      t.string :port

      t.timestamps null: false
    end
  end
end
