
# Create a user or two
jamal = User.create(name: "Jamal", password_hash: "cheese")
peter = User.create(name: "Peter", password_hash: "cheese")


# Give Jamal a tree
jamal.trees.create(name: "Jamal's First Tree", description: "This is a very bushy tree, IMO")

# give Jamal's tree a root node
#jamal.trees.first.root_node.create(value: 42)
