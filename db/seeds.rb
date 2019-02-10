# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ActiveRecord::Base.transaction do
  Admin.create(email: 'admin@sample.com', password: 'hogehoge')

  user = User.create(email: 'user@sample.com', password: 'hogehoge')
  user.confirm

  Product.create(name: 'ほうれん草',        price: 150, description: "ほうれん草\n美味しいよー",       hidden: false, sort_no: 0, product_image: Rack::Test::UploadedFile.new(Rails.root.join('db/samples/sample01.jpg'), 'image/jpeg'))
  Product.create(name: '食べかけのキャペツ', price: 120, description: "食べかけのキャペツ\n美味しいよー", hidden: false, sort_no: 1, product_image: Rack::Test::UploadedFile.new(Rails.root.join('db/samples/sample02.jpg'), 'image/png'))
  Product.create(name: 'しなびたカブ',      price: 200, description: "カブ\n美味しいよー",             hidden: false,  sort_no: 2, product_image: Rack::Test::UploadedFile.new(Rails.root.join('db/samples/sample03.jpg'), 'image/png'))
  Product.create(name: '玉ねぎ',           price: 50 , description: "玉ねぎ\n美味しいよー",           hidden: false,  sort_no: 3, product_image: Rack::Test::UploadedFile.new(Rails.root.join('db/samples/sample04.jpg'), 'image/png'))
  Product.create(name: '実家のねぎ',        price: 300, description: "ねぎ\n美味しいよー",             hidden: true,  sort_no: 4, product_image: Rack::Test::UploadedFile.new(Rails.root.join('db/samples/sample05.jpg'), 'image/png'))
end
