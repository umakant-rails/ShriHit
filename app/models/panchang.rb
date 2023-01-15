class Panchang < ApplicationRecord
	# validates :date, :panchang_tithi, :panchang_month, :paksh, :title,
	# 	:panchang_type, :vikram_samvat, :description, :year, presence: true

	validates :date, :panchang_tithi, :panchang_month, :paksh,
		:panchang_type, :vikram_samvat, :year, presence: true

	TYPE = ['राधावल्लभ संप्रदाय']
	TITHIYA = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
	PAKSH = ['शुक्ळ पक्ष', 'कृष्ण पक्ष']
	MONTH = ['चैत्र', 'बैसाख', 'जयेष्ट', 'अषाढ़', 'श्रावण', 'भाद्रपद', 'अश्विन', 'कार्तिक', 'अग्रहायण/अगहन', 'पौष', 'माघ', 'फाल्गुन']
	WEEKDAYS = ["रविवार", "मंगलवार", "रविवार", "बुद्धवार", "बृहस्पतिवार", "शुक्रवार", "शनिवार"]
	HIN_MONTH = ['जनवरी', 'फरवरी', 'मार्च', 'अप्रैल', 'मई', 'जून', 'जुलाई', 'अगस्त', 'सितम्बर', 'अक्टूबर', 'नवम्बर', 'दिसम्बर']
	HIN_MONTH_SHORT = ['जन', 'फर', 'मार्च', 'अप्रैल', 'मई', 'जून', 'जुलाई', 'अग', 'सित', 'अक्टू', 'नव', 'दिस']
end

#बैसाख जयेष्ट अषाढ़  श्रावण भाद्रपद अश्विन कार्तिक अग्रहायण/अगहन पौष माघ फाल्गुन
