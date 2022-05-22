class HomesController < ApplicationController
	before_action :authenticate_user!

	def index
		@articles = current_user.articles
		@authors = current_user.authors
	end

end
