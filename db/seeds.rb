# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Role.create(name: 'Admin') if Role.where(name: 'Admin').blank?
Role.create(name: 'Contributor') if Role.where(name: 'Contributor').blank?
User.create(username: 'umakant005', email: 'umakantrajpoot@gmail.com', 
  password: '12345678', password_confirmation: '12345678', role_id:1,
  confirmed_at: Date.today) if User.where(email: 'umakantrajpoot@gmail.com').blank?

ArticleType.create(name: 'पद') if ArticleType.where(name: 'पद').blank?
ArticleType.create(name: 'कवित्त') if ArticleType.where(name: 'कवित्त').blank?
ArticleType.create(name: 'सवैया') if ArticleType.where(name: 'सवैया').blank?
ArticleType.create(name: 'दोहा') if ArticleType.where(name: 'दोहा').blank?

Event.create(name: 'व्याहुला') if Event.where(name: 'व्याहुला').blank?
Event.create(name: 'जन्मोत्सव') if Event.where(name: 'जन्मोत्सव').blank?
Event.create(name: 'होली') if Event.where(name: 'होली').blank?
 