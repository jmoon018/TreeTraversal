class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |node|
      node.integer  :value
      node.integer  :tree_id
      node.integer  :node_id

      node.timestamps
    end
  end
end
