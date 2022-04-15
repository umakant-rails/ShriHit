# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or create!d alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create!([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create!(name: "Luke", movie: movies.first)
Role.create!(name: 'Admin') if Role.where(name: 'Admin').blank?
Role.create!(name: 'Contributor') if Role.where(name: 'Contributor').blank?
User.create!(username: 'umakant005', email: 'umakantrajpoot@gmail.com', 
  password: '12345678', password_confirmation: '12345678', role_id:1,
  confirmed_at: Date.today) if User.where(email: 'umakantrajpoot@gmail.com').blank?

ArticleType.create!(name: 'पद') if ArticleType.where(name: 'पद').blank?
ArticleType.create!(name: 'कवित्त') if ArticleType.where(name: 'कवित्त').blank?
ArticleType.create!(name: 'सवैया') if ArticleType.where(name: 'सवैया').blank?
ArticleType.create!(name: 'दोहा') if ArticleType.where(name: 'दोहा').blank?

Theme.create!(name: 'व्याहुला') if Theme.where(name: 'व्याहुला').blank?
Theme.create!(name: 'जन्मोत्सव') if Theme.where(name: 'जन्मोत्सव').blank?
Theme.create!(name: 'होली') if Theme.where(name: 'होली').blank?
 
Context.create!(name: 'वन विहार') if Context.where(name: 'वन विहार').blank?
Context.create!(name: 'श्रृंगार') if Context.where(name: 'श्रृंगार').blank?
Context.create!(name: 'शरद ऋतु') if Context.where(name: 'शरद ऋतु').blank?
Context.create!(name: 'वर्षा ऋतु') if Context.where(name: 'वर्षा ऋतु').blank?
Context.create!(name: 'नौका विहार') if Context.where(name: 'नौका विहार').blank?

Sampradaya.create!(name: 'माध्व सम्प्रदाय') if Sampradaya.where(name: 'माध्व सम्प्रदाय').blank?
Sampradaya.create!(name: 'वल्लभ सम्प्रदाय') if Sampradaya.where(name: 'वल्लभ सम्प्रदाय').blank?
Sampradaya.create!(name: 'निम्बार्क सम्प्रदाय') if Sampradaya.where(name: 'निम्बार्क सम्प्रदाय').blank?
Sampradaya.create!(name: 'रामानंदी संप्रदाय') if Sampradaya.where(name: 'रामानंदी संप्रदाय').blank?