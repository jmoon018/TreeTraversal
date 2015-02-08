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
