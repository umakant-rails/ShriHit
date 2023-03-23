# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or create!d alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create!([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create!(name: "Luke", movie: movies.first)
Role.create!(name: 'Super Admin') if Role.where(name: 'Super Admin').blank?
Role.create!(name: 'Admin') if Role.where(name: 'Admin').blank?
Role.create!(name: 'Contributor') if Role.where(name: 'Contributor').blank?

State.create!(name: "Arunachal Pradesh") if State.where(name: "Arunachal Pradesh").blank?
State.create!(name: "Himachal Pradesh") if State.where(name: "Himachal Pradesh").blank?
State.create!(name: "Jammu & Kashmir") if State.where(name: "Jammu & Kashmir").blank?
State.create!(name: "Andhra Pradesh") if State.where(name: "Andhra Pradesh").blank?
State.create!(name: "Madhya Pradesh") if State.where(name: "Madhya Pradesh").blank?
State.create!(name: "Uttar Pradesh") if State.where(name: "Uttar Pradesh").blank?
State.create!(name: "Chhattisgarh") if State.where(name: "Chhattisgarh").blank?
State.create!(name: "Maharashtra") if State.where(name: "Maharashtra").blank?
State.create!(name: "West Bengal") if State.where(name: "West Bengal").blank?
State.create!(name: "Uttarakhand") if State.where(name: "Uttarakhand").blank?
State.create!(name: "Rajasthan") if State.where(name: "Rajasthan").blank?
State.create!(name: "Tamilnadu") if State.where(name: "Tamilnadu").blank?
State.create!(name: "Telangana") if State.where(name: "Telangana").blank?
State.create!(name: "Meghalaya") if State.where(name: "Meghalaya").blank?
State.create!(name: "Jharkhand") if State.where(name: "Jharkhand").blank?
State.create!(name: "Karnatka") if State.where(name: "Karnatka").blank?
State.create!(name: "Hariyana") if State.where(name: "Hariyana").blank?
State.create!(name: "Nagaland") if State.where(name: "Nagaland").blank?
State.create!(name: "Tripura") if State.where(name: "Tripura").blank?
State.create!(name: "Manipur") if State.where(name: "Manipur").blank?
State.create!(name: "Punjab") if State.where(name: "Punjab").blank?
State.create!(name: "Gujrat") if State.where(name: "Gujrat").blank?
State.create!(name: "Kerala") if State.where(name: "Kerala").blank?
State.create!(name: "Sikkim") if State.where(name: "Sikkim").blank?
State.create!(name: "Delhi") if State.where(name: "Delhi").blank?
State.create!(name: "Bihar") if State.where(name: "Bihar").blank?
State.create!(name: "Udisa") if State.where(name: "Udisa").blank?
State.create!(name: "Asam") if State.where(name: "Asam").blank?
State.create!(name: "Goa") if State.where(name: "Goa").blank?

ArticleType.create!(name: 'पद', user_id: 1) if ArticleType.where(name: 'पद').blank?
ArticleType.create!(name: 'कवित्त', user_id: 1) if ArticleType.where(name: 'कवित्त').blank?
ArticleType.create!(name: 'सवैया', user_id: 1) if ArticleType.where(name: 'सवैया').blank?
ArticleType.create!(name: 'दोहा', user_id: 1) if ArticleType.where(name: 'दोहा').blank?
ArticleType.create!(name: 'भजन', user_id: 1) if ArticleType.where(name: 'भजन').blank?
ArticleType.create!(name: 'अन्य', user_id: 1) if ArticleType.where(name: 'अन्य').blank?

Theme.create!(name: 'व्याहुला', user_id: 1) if Theme.where(name: 'व्याहुला').blank?
Theme.create!(name: 'जन्मोत्सव', user_id: 1) if Theme.where(name: 'जन्मोत्सव').blank?
Theme.create!(name: 'होली', user_id: 1) if Theme.where(name: 'होली').blank?
Theme.all.each{ | theme |
  ThemeChapter.create(user_id:1, theme_id: theme.id, name: "#{theme.name}_विविध _प्रकरण") if ThemeChapter.where(name: "#{theme.name}_विविध _प्रकरण").blank?
}

Context.create!(name: 'अन्य', is_approved: true, user_id: 1) if Context.where(name: 'अन्य').blank?
Context.create!(name: 'वन विहार', is_approved: true, user_id: 1) if Context.where(name: 'वन विहार').blank?
Context.create!(name: 'श्रृंगार', is_approved: true, user_id: 1) if Context.where(name: 'श्रृंगार').blank?
Context.create!(name: 'शरद ऋतु', is_approved: true, user_id: 1) if Context.where(name: 'शरद ऋतु').blank?
Context.create!(name: 'वर्षा ऋतु', is_approved: true, user_id: 1) if Context.where(name: 'वर्षा ऋतु').blank?
Context.create!(name: 'नौका विहार', is_approved: true, user_id: 1) if Context.where(name: 'नौका विहार').blank?

Sampradaya.create!(name: 'अज्ञात') if Sampradaya.where(name: 'अज्ञात').blank?
Sampradaya.create!(name: 'माध्व सम्प्रदाय') if Sampradaya.where(name: 'माध्व सम्प्रदाय').blank?
Sampradaya.create!(name: 'वल्लभ सम्प्रदाय') if Sampradaya.where(name: 'वल्लभ सम्प्रदाय').blank?
Sampradaya.create!(name: 'निम्बार्क सम्प्रदाय') if Sampradaya.where(name: 'निम्बार्क सम्प्रदाय').blank?
Sampradaya.create!(name: 'रामानंदी संप्रदाय') if Sampradaya.where(name: 'रामानंदी संप्रदाय').blank?
Sampradaya.create!(name: 'रसिक संप्रदाय') if Sampradaya.where(name: 'रसिक संप्रदाय').blank?

Author.create!(name: 'सूरदास', is_approved: true, is_saint: true, user_id: 1) if Author.where(name: 'सूरदास').blank?
Author.create!(name: 'कुम्भनदास', is_approved: true, is_saint: true, user_id: 1) if Author.where(name: 'कुम्भनदास').blank?
Author.create!(name: 'चतुर्भुजदास', is_approved: true, is_saint: true, user_id: 1) if Author.where(name: 'चतुर्भुजदास').blank?
Author.create!(name: 'छीतस्वामी', is_approved: true, is_saint: true, user_id: 1) if Author.where(name: 'छीतस्वामी').blank?
Author.create!(name: 'गोविंदस्वामी', is_approved: true, is_saint: true, user_id: 1) if Author.where(name: 'गोविंदस्वामी').blank?
Author.create!(name: 'कृष्णदास', is_approved: true, is_saint: true, user_id: 1) if Author.where(name: 'कृष्णदास').blank?
Author.create!(name: 'नंददास', is_approved: true, is_saint: true, user_id: 1) if Author.where(name: 'नंददास').blank?
Author.create!(name: 'परमानन्ददास', is_approved: true, is_saint: true, user_id: 1) if Author.where(name: 'परमानन्ददास').blank?
Author.create!(name: 'अज्ञात', is_approved: true, is_saint: true, user_id: 1) if Author.where(name: 'अज्ञात').blank?


# ScriptureType.create!(name: "वेद") if ScriptureType.where(name: "वेद").blank?
# ScriptureType.create!(name: "पुराण") if ScriptureType.where(name: "पुराण").blank?
# ScriptureType.create!(name: "उपनिषद") if ScriptureType.where(name: "उपनिषद").blank?
# ScriptureType.create!(name: "स्मृति") if ScriptureType.where(name: "स्मृति").blank?
# ScriptureType.create!(name: "श्रुतियाँ") if ScriptureType.where(name: "श्रुतियाँ").blank?
# ScriptureType.create!(name: "नीति") if ScriptureType.where(name: "नीति").blank?
# ScriptureType.create!(name: "शास्त्र") if ScriptureType.where(name: "शास्त्र").blank?
# ScriptureType.create!(name: "दर्शन") if ScriptureType.where(name: "दर्शन").blank?
ScriptureType.create!(name: "ग्रन्थ") if ScriptureType.where(name: "ग्रन्थ").blank?
ScriptureType.create!(name: "रसिक वाणी") if ScriptureType.where(name: "वाणीजी").blank?
ScriptureType.create!(name: "अष्टयाम") if ScriptureType.where(name: "अष्टयाम").blank?

ScriptureType.create!(name: "आरती") if ScriptureType.where(name: "आरती").blank?
ScriptureType.create!(name: "चालीसा") if ScriptureType.where(name: "चालीसा").blank?

ScriptureType.create!(name: "स्त्रोत") if ScriptureType.where(name: "स्त्रोत").blank?
ScriptureType.create!(name: "सहस्त्रनाम") if ScriptureType.where(name: "सहस्त्रनाम").blank?
ScriptureType.create!(name: "कवच") if ScriptureType.where(name: "कवच").blank?
ScriptureType.create!(name: "अष्टक") if ScriptureType.where(name: "अष्टक").blank?
