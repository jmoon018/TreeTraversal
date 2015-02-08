require_relative '../spec_helper.rb'

describe "can generate new users/trees/nodes w/ proper relations" do
  describe "user methods (create, create tree, etc) work" do

    # reset everything before testing
    before(:each) do
      Tree.destroy_all
      User.destroy_all
      Node.destroy_all
    end

    # variables for a test user
    let(:jamal_name) { "Jamal" }
    let(:jamal_password) { "cheese" }
    let(:jamal) {
      User.create(name: jamal_name,
        password: jamal_password)
    }

    it "can create an empty user" do
      user = User.create()
      expect(User.all.count).to be(1)
    end

    it "can create a user with name" do
      expect(jamal.name).to be(jamal_name)
    end

    # actual password != password hash
    it "can create a user with a password hash" do
      expect(jamal.password_hash).to_not be(jamal_password)
    end

    it "can create a user with 'created_at' property" do
      expect(jamal.created_at.utc.to_i).to eq(Time.now.to_i)
    end

    it "can create a user with 'updated_at' property" do
      expect(jamal.created_at.utc.to_i).to eq(Time.now.to_i)
    end

    it "can create an empty tree" do
      jamal.trees.create()
      expect(Tree.count).to be(1)
    end

    it "can create an empty tree that belongs to user" do
      tree = jamal.trees.create()
      expect(jamal.trees.first).to eq(tree)
    end
  end

  describe "tree methods (create, create node, etc) work" do

    before(:each) do
      Tree.destroy_all
      User.destroy_all
      Node.destroy_all
    end

    let (:t_name) { "Bushy Tree" }

    let (:t_desc) { "This tree demonstrates what a bushy tree looks like -- "}
    let (:t_tree) {
      Tree.create(name: t_name,
        description: t_desc)
    }

    it "can create an empty tree" do
      Tree.create()
      expect(Tree.all.count).to be(1)
    end

    it "can create a tree with a name" do
      expect(t_tree.name).to eq(t_name)
    end

    it "can create a tree with a description" do
      expect(t_tree.description).to eq(t_desc)
    end

    it "initially has an empty root node" do
      expect(t_tree.node).to be(nil)
    end

    it "can create a root node" do
      t_tree.create_node()
      expect(t_tree.node).to_not be(nil)
    end

    it "has a 'updated_at' property" do
      expect(t_tree.updated_at.utc.to_i).to eq(Time.now.to_i)
    end

    # this works because 't_tree' is actually initialized when it is first created
    # also, Time.now.to_i counts in seconds, so it isn't super anal about the specific time
    # if the code had been:
    # t_tree
    # sleep 1 # or more
    # expect(t_tree.cre ... eq(Time.now.to_i)
    # it would return false, because t_tree has been initialized a second before
    it "has a 'created_at' property" do
      expect(t_tree.created_at.utc.to_i).to eq(Time.now.to_i)
    end

    describe "tree algorithms (depth first search, minimax, etc)" do
      let(:dfs_tree) {
        t = Tree.create()

        # the values are carefully chosen so that a depth first search
        # will returns nodes with increasing value: 0, 1, 2, etc
        root = t.create_node(value: 0)
        n1 = root.create_node(value: 1)
        n2 = root.create_node(value: 3)
        n3 = root.create_node(value: 6)

        n1.create_node(value: 2)
        n2.create_node(value: 4)
        n2.create_node(value: 5)
        n3.create_node(value: 7)
        return t
      }

      let (:minimax_tree_1) {
        t = Tree.create()

        # depth 0
        root = t.create_node()

        # depth 1
        n1 = root.create_node()
        n2 = root.create_node()
        n3 = root.create_node()

        # depth 2
        n4 = n1.create_node()
        n5 = n1.create_node()

        n6 = n2.create_node()

        n7 = n3.create_node()
        n8 = n3.create_node()
        n9 = n3.create_node()

        # depth 3
        n10 = n4.create_node(value: 6)
        n11 = n4.create_node(value: -3)
        n12 = n4.create_node(value: 10)

        n13 = n5.create_node(value: 5)
        n14 = n5.create_node(value: 0)
        n15 = n5.create_node(value: 6)

        n16 = n6.create_node(value: 5)

        n17 = n7.create_node(value: -4)

        n18 = n8.create_node(value: 8)
        n19 = n8.create_node(value: -9)

        n20 = n9.create_node(value: -6)
        n21 = n9.create_node(value: 0)
        n22 = n9.create_node(value: 5)

        return t
      }

      it "iterates through all the nodes in the tree" do
        expect(dfs_tree.depth_first_search().count).to be(8)
      end

      it "iterates through all the nodes in the proper order" do
        # when i made the tree and nodes, they were in a specific order
        ordered = true
        arr = dfs_tree.depth_first_search()
        arr.each_with_index {|node, index| oredered = false if node.value != index}
        expect(ordered).to be(true)
      end

      it "minimax picks the right value" do
        #dfs = minimax_tree_1.depth_first_search()
        #dfs.each {|node| puts node.value}
        #expect(dfs.count).to be (23)
       expect(minimax_tree_1.minimax({depth: 3, node: minimax_tree_1.node, maximize: true})).to be(6)
      end
    end
  end

  describe "node methods: " do
    before(:each) do
      Tree.destroy_all
      User.destroy_all
      Node.destroy_all
    end

    let(:node) { Node.create }

    it "can create an empty node" do
      Node.create
      expect(Node.count).to be(1)
    end

    it "can create a node that belongs to a tree" do
      t = Tree.create
      n = t.create_node()
      expect(n.tree).to be(t)
    end

    it "has a value property" do
      n = Node.create(value: 42)
      expect(n.value).to be(42)
    end

    it "can create another node" do
      node.create_node()
      expect(node.nodes.count).to be(1)
    end

    it "can have multiple nodes" do
      node.create_node()
      node.create_node()
      node.create_node()
      expect(node.nodes.count).to be(3)
    end

    it "can have multiple nodes that have multiple nodes" do
      # 1 'root' node is above, in let :node ..
      # node

      # 3 nodes
      n1 = node.create_node()
      n2 = node.create_node()
      n3 = node.create_node()

      # 6 more nodes
      n1.create_node()
      n1.create_node()
      n2.create_node()
      n3.create_node()
      n3.create_node()
      n3.create_node()

      # 10 nodes total
      expect(Node.count).to be(10)
    end

    it "has a 'created_at' property" do
      expect(node.created_at.utc.to_i).to eq(Time.now.to_i)
    end

    it "has a 'updated_at' property" do
      expect(node.updated_at.utc.to_i).to eq(Time.now.to_i)
    end
  end
end
