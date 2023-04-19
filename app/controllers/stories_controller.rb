class StoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_story, only: %i[show edit update destroy]

  def index
    @stories = Story.all
  end

  def new
    @sants = Author.where(is_saint:true).collect { |a| [a.name, a.id]}
    @scripture_type = ScriptureType.where(name: 'story')
    @scriptures = @scripture_type.scriptures rescue []
    @story = Story.new
  end

  def create
    @story = current_user.stories.new(story_params)

    respond_to do |format|
      if @story.save
        format.html { redirect_to story_url(@story), notice: "Story was successfully created." }
        format.json { render :show, status: :created, location: @story }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
    @sants = Author.where(is_saint:true).collect { |a| [a.name, a.id]}
    @scripture_type = ScriptureType.where(name: 'story')
    @scriptures = @scripture_type.scriptures rescue []
  end

  def update
    respond_to do |format|
      if @story.update(story_params)
        format.html { redirect_to story_url(@story), notice: "Story was successfully updated." }
        format.json { render :show, status: :ok, location: @story }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @story.destroy

    respond_to do |format|
      format.html { redirect_to stories_url, notice: "Story was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_story
    @story = Story.find(params[:id])
  end

  # def verify_admin
  #   if !current_user.is_admin && !current_user.is_super_admin
  #     redirect_to new_user_session_path
  #   end
  # end

  def story_params
    params.fetch(:story, {}).permit(:title, :story, :index, :scripture_id, :author_id, :user_id)
  end

end
