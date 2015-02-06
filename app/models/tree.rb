class Tree < ActiveRecord::Base
  belongs_to :user
  has_one :node
end
