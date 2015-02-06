class CreateTrees < ActiveRecord::Migration
  def change
    create_table :trees do |tree|
      tree.string   :name
      tree.string   :description
      tree.integer  :user_id
      tree.integer  :node_id

      tree.timestamps
    end
  end
end
