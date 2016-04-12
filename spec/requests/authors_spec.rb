require 'rails_helper'

RSpec.describe "Authors", type: :request do
	let(:headers){{'Content-Type' => 'application/json'}}
	let(:who) {FFaker::Name.name}
	let(:phone) {FFaker::PhoneNumber.phone_number}
  describe "GET /authors" do
    it "works! (now write some real specs)" do
      get authors_path
      expect(response).to have_http_status(200)
      body = JSON.parse(response.body)
      puts body.inspect
    end
  end

  describe "GET /authors/:id" do
    it "GET /authors/:id" do
      get "/authors/1"
      expect(response).to have_http_status(200)
      body = JSON.parse(response.body)
      puts body.inspect
    end
  end

  describe "POST /authors/" do
    it "Successful POST /authors/" do
      author={
        data: {
          type: "authors",
          attributes:{
            name: who,
            phone: FFaker::PhoneNumber.phone_number
          }
        }
      }
      # author = {
      # 	author:{
      #       name: who,
      #       phone: FFaker::PhoneNumber.phone_number
      #     }
      # }
      post "/authors",author.to_json ,headers
      expect(response).to have_http_status(201)
      body = JSON.parse(response.body)
      puts body.inspect
    end

    it "Failed POST /authors/" do
    	author={
    		data: {
    			type: "authors",
    			attributes:{
    				name: ''
    			}
    		}
    	}
    	post "/authors", author.to_json, headers
    	expect(response).to have_http_status(422)
    	body = JSON.parse(response.body)
    	puts body.inspect
    end

    #batch_create
    it "Successful POST /authors/batch_create" do
    	author= Hash.new
    	author["data"] = []
    	10.times do 
    		author["data"].push({type: "authors", attributes: {name: FFaker::Name.name, phone: FFaker::PhoneNumber.phone_number}})
    	end

    	post "/authors/batch_create", author.to_json, headers
    	puts response.status
    	body = JSON.parse(response.body)
    	puts body
    end

    it "Failed POST /authors/batch_create" do
    	author = Hash.new
    	author["data"]=[]
    	10.times do |i|
    		author["data"].push({type: "authors", attributes: {name: i.even? ? '' : FFaker::Name.name, phone: FFaker::PhoneNumber.phone_number}})
    	end

    	puts author["data"].inspect
    	post "/authors/batch_create", author.to_json, headers
    	puts response.status
    	body = JSON.parse(response.body)
    	puts body
    end

  end

  describe "PUT /authors/:id" do
  	it "PUT /authors/:id" do
  		new_name = FFaker::Name.name
  		new_phone = FFaker::PhoneNumber.phone_number
  		# FactoryGirl.create :author, name:who, phone: phone, id: 1
  		author = {
  			data: {
  				type: "authors",
  				id: 1,
  				attributes:{
  					name: new_name,
  					phone: new_phone
  				}
  			}
  		}

  		put "/authors/1", author.to_json, headers

  		expect(response).to have_http_status(200)
      body = JSON.parse(response.body)
      puts body.inspect
  		author_name = body["data"]["attributes"]["name"]
  		expect(author_name) == new_name
  	end

  	#batch_update
  	it "PUT /authors/batch_update" do
  		author = Hash.new
  		author["data"] = []
  		for i in 1..10 do
  			FactoryGirl.create :author, name: FFaker::Name.name, phone: FFaker::PhoneNumber.phone_number
  			author["data"].push({type: "authors", id: i+1, attributes: {name: FFaker::Name.name, phone: FFaker::PhoneNumber.phone_number}})
  		end

  		put "/authors/batch_update", author.to_json, headers

  		body = JSON(response.body)
  		puts body.inspect

  	end

  	it "Failed PUT /authors/batch_update" do
    	author = Hash.new
    	author["data"]=[]
    	10.times do |i|
    		FactoryGirl.create :author, name: FFaker::Name.name, phone: FFaker::PhoneNumber.phone_number
    		author["data"].push({type: "authors", id: i+1, attributes: {name: i.even? ? '' : FFaker::Name.name, phone: FFaker::PhoneNumber.phone_number}})
    	end

    	put "/authors/batch_update", author.to_json, headers
    	puts response.status
    	body = JSON.parse(response.body)
    	puts body
    end
  end

end
