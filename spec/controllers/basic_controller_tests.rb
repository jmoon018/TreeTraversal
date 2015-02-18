require 'spec_helper'
require 'rack/test'


describe "controller" do 
	before (:all) do  
		User.delete_all
		Tree.delete_all
		Node.delete_all
	end

	let (:user_name) { "theUSER" }
	let (:user) {
		tree
		User.create()
	}

	let (:tree_name) { "theTREE" }
	let (:tree) { 
		user
		user.trees.create()
	}

	it "home page loads" do
		get '/'
		expect(last_response.status).to eq(200)
	end

	it "learn page loads" do 
		get '/learn'
		expect(last_response.status).to eq(200)
	end

	describe "tree/node testing .. /trees/:treename" do

		it "gives proper error without authentication" do
			get "/trees/theTree"
			expect(last_response.status).to be(401)
		end			

		it "gives an error for not having the right url name (invalid tree name)" do
			user = User.create(name: "askjga", password: "pw")
			session = {'rack.session' => {:current_user_id => user.id}}
			get "/trees/t;sgjpa'", {}, session
			expect(last_response.status).to be(404)
		end

		it "works with authentication" do
			user = User.create(name: "2bob", password: "pw")
			node = Node.create()
			
			treeName = "#{user.name}#{user.id}" 
			user.trees.create({node_id: node.id, name: treeName, description: "lalakak"})
			puts "USER ID: #{user.id}" 
			session = {'rack.session' => {:current_user_id => user.id}}
			get "/trees/#{treeName}", {}, session
			expect(last_response.status).to be(200)	
		end
		
		it "provides the right title for the tree page" do
			user = User.create(name: "askjga", password: "pw")
			user.trees.create(name: "treename")
			session = {'rack.session' => {:current_user_id => user.id}}
			get "/trees/treename", {}, session
			expect(last_response.body).to include("treename")
		end

	end
end
