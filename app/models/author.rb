class Author < ActiveRecord::Base
	validates :name, presence: true, uniqueness: true, length: {minimum: 5}
	# validates :phone, presence: true

	def self.batch_create(author_content)
		result={success: true, message: "authors created"}
		# logger.error " ========== data_validation return #{data_validation(author_content)}"
		if data_validation(author_content)
			Author.transaction do
				body = JSON.parse(author_content)
				body["data"].each_with_index do |author_hash, i|
					Author.create!(author_hash["attributes"])
				end
			end
		else
			result[:success] = false
			result[:message] = "authors not created, because there are #{@invalid_data["data"].size} invalid data"
		end
		return result
	end

	def self.batch_update(author_content)
		Author.transaction do
			body = JSON.parse(author_content)
			body["data"].each_with_index do |author_hash, i|
				author = Author.find(author_hash["id"])
				author.update!(author_hash["attributes"]) if author
			end
		end
	end

	def self.data_validation(author_content)
		  @invalid_data = Hash.new
    	@invalid_data["data"]=[]
    	body = JSON.parse(author_content)
    	body["data"].each_with_index do |row_hash, i|
    		author = Author.new(row_hash["attributes"])
    		@invalid_data["data"].push(row_hash) if !author.valid?
    	end
    	# logger.error 8888888888888888888
    	# logger.error "=========== #{@invalid_data["data"].inspect}"

    	return false if @invalid_data["data"].size > 0

    	return true
	end

end
