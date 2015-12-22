require 'json'

localities = JSON.parse(File.read('localities/localitiesBangalore.json'))
cabpool_types = JSON.parse(File.read('cabpool_type/cabpool_types.json'))

localities.each do |locality|
  locality_name = locality["LOCATION"]
  Locality.create!(name: locality_name)
end

cabpool_types.each do |cabpool_type|
  cabpool_type_name = cabpool_type["TYPE"]
  CabpoolType.create!(name: cabpool_type_name)
end

20.times do
  name = Faker::Name.name
  email = Faker::Internet.email
  emp_id = Faker::Number.number(5)
  address = Faker::Address.street_address
  locality = Locality.all.sample
  phone_no = Faker::PhoneNumber.phone_number
  User.create!(name: name, email: email, emp_id: emp_id, address: address, locality: locality, "phone_no": phone_no)
end

User.create!(id: 100, name: 'Deepika Srinivasa Iyengar Varadarajan', email: 'vdeepika@thoughtworks.com', emp_id: '18078', address: "Blah on Mars", locality: Locality.first , phone_no: "+91 9080706021")
User.create!(id: 101, name: 'Sandeep Hegde', email: 'sandeeph@thoughtworks.com', emp_id: '18071', address: "Blah on Mars", locality: Locality.first , phone_no: "+91 9080706033")

current_localities = Locality.all
current_cabpool_types = CabpoolType.all
current_users = User.all
current_users = current_users.reject{ |user| user.id == 100 || user.id == 101 }


4.times do |cabpool_number|
  timein = Faker::Time.between(2.days.ago, Time.now, :all)
  timeout = Faker::Time.between(2.days.ago, Time.now, :all)
  capacity = 4
  built_localities = []
  built_users = []

  3.times do
    locality = current_localities.sample
    built_localities << locality
    current_localities = current_localities.reject{ |l| l.name == locality.name }
  end

  no_of_users_in_cabpool = cabpool_number == 3 ? capacity : (capacity - 2)

  no_of_users_in_cabpool.times do
    user = current_users.sample
    built_users << user
    current_users = current_users.reject{ |u| u.name == user.name }
  end

  cabpool = Cabpool.new(timein: timein, timeout: timeout, number_of_people: capacity)
  cabpool.localities = built_localities
  cabpool.users = built_users
  cabpool.cabpool_type = current_cabpool_types.first
  cabpool.save!
end

Request.create!(user_id: 1, cabpool_id: 1)