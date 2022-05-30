class HomesController < ApplicationController
	before_action :authenticate_user!

	def index
		@articles = current_user.articles.order("created_at DESC")
		@authors = current_user.authors.order("name ASC")
	end

end
