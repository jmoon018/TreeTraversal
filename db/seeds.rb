require 'faker'


# Change these if you want
DEFAULT_USERS = 10
DEFAULT_TREES = (1..3).to_a
DEFAULT_TREE_DEPTH = (2..4).to_a
DEFAULT_BRANCHING_FACTOR = (2..6).to_a
DEFAULT_VALUES = (-100..100).to_a

num = ARGV[1].to_i
num = DEFAULT_USERS if num == 0 # create 10 users by default

def seed_tree(args = {})
  users_count = args[:users_count] || DEFAULT_USERS
  trees_count = args[:trees_count]
  tree_depth = args[:tree_depth]
  branching_factor = args[:branching_factor]
  value_range = args[:value_range] || DEFAULT_VALUES

  for user_index in 1..users_count
    first_name = args[:first_name] || Faker::Name.first_name
    password = args[:password] || Faker::Internet.password(10)

    user = User.create(name: first_name, password: password)

    # make a random number of trees
    trees_count = trees_count || DEFAULT_TREES.sample
    for tree_index in 1..trees_count
      tree_name = first_name + "'s Tree"
      desc = "This tree belongs to #{first_name} and may have a few nodes or... a lot, really. It just depends on chance."

      # create the tree
      tree = user.trees.create(name: tree_name,
        description: desc)
      root = tree.create_node()
      nodes = [root]

      # populate the tree in each depth
      depth = tree_depth || DEFAULT_TREE_DEPTH.sample.to_i
      for depth_index in 1..depth
        # find the number of nodes per each depth
        node_count = branching_factor || DEFAULT_BRANCHING_FACTOR.sample

        # make a duplicate because we dont want to perpetually
        # add to the array.. the each loop would never end
        nodes.dup.each do |node|
          parent_node = nodes.shift # remove the current node
          for node_creation_index in 1..node_count
            if depth_index != depth
              nodes << parent_node.create_node()
            else
              nodes << parent_node.create_node(value: value_range.sample)
            end
          end
        end
      end
    end
  end
end

#seed_tree({users_count: 1, trees_count: 1, tree_depth: 6, branching_factor: 4, first_name: "Jamal", password: "bigtree"})
seed_tree()
