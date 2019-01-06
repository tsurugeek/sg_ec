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

  Product.create(name: 'みかん', price: 1234, description: "みかんでーす\n美味しいよー", hidden: false, sort_no: 0, product_image: Rack::Test::UploadedFile.new(Rails.root.join('spec/support/sample1.jpg'), 'image/jpeg'))
  Product.create(name: 'りんご', price: 2345, description: "りんごでーす\n美味しいよー", hidden: false, sort_no: 1, product_image: Rack::Test::UploadedFile.new(Rails.root.join('spec/support/sample2.png'), 'image/png'))
  Product.create(name: 'いちご', price: 3456, description: "いちごでーす\n美味しいよー", hidden: true,  sort_no: 2, product_image: Rack::Test::UploadedFile.new(Rails.root.join('spec/support/sample3.png'), 'image/png'))
end
