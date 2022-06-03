module AuthorsHelper

  def get_sampradaya_list
    sampradayas = Sampradaya.all.collect{|e| [e.name, e.id]}
    sampradayas.push(['सम्प्रदाय का नाम टाइप करे', ''])
    return sampradayas
  end
  
end
