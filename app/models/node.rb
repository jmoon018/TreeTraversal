class Node < ActiveRecord::Base
  belongs_to :node
  has_many :nodes
  belongs_to :tree

  # A child must point to its parent, hence 'node_id: self.id'
  # for whatever reason, active record did not do this automatically
  def create_node (args = {})
    Node.create(node_id: self.id, value: args[:value], tree_id: nil)
  end
end
