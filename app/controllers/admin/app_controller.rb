class Admin::AppController < ApplicationController
  before_action :set_required_data

  private

  def set_required_data
    @notifications = []

    @contexts_pending = Context.pending
    @authors_pending = Author.pending
    @articles_pending = Article.pending

    @contexts_new = Context.where("created_at > ? ", current_user.last_sign_in_at)
    @authors_new  = Author.where("created_at > ? ", current_user.last_sign_in_at)
    @articles_new = Article.where("created_at > ? ", current_user.last_sign_in_at)

    @notifications.push({key1: "रचनायें", key2: "#{@articles_pending.length} रचनायें स्वीकृत हेतु लंबित है"}) if @articles_pending.present?
    @notifications.push({key1: "रचनायें", key2: "#{@articles_new.length} नई रचनायें दर्ज की गई है"}) if @articles_new.present?
    @notifications.push({key1: "प्रसंग", key2: "#{@contexts_pending.length} प्रसंग स्वीकृत हेतु लंबित है"}) if @contexts_pending.present?
    @notifications.push({key1: "प्रसंग", key2: "#{@contexts_new.length} नए प्रसंग दर्ज किये गए है"}) if @contexts_new.present?
    @notifications.push({key1: "रचनाकार", key2: "#{@authors_pending.length} रचनाकार स्वीकृत हेतु लंबित है"}) if @authors_pending.present?
    @notifications.push({key1: "रचनाकार", key2: "#{@authors_new.length} नए रचनाकार दर्ज किये गए है"}) if @authors_new.present?
  end

end
