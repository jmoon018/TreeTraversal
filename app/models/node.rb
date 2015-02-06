class Node < ActiveRecord::Base
  has_many :nodes
  belongs_to :node
  belongs_to :tree
end
