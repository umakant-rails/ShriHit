module UserProfilesHelper

  def get_states
    states = State.all.collect{|e| [e.name, e.id]}
    return states
  end

end
