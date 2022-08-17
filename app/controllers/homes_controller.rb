class HomesController < ApplicationController
	before_action :authenticate_user!

	def index
		@articles = current_user.articles.order("created_at DESC")
		@authors = current_user.authors.order("name ASC")
	end

	def set_layout
		if params[:layout_name].present?
			session[:layout_name] = params[:layout_name]
		end
		redirect_back_or_to homes_path
	end

end
