require 'json'

localities = JSON.parse(File.read('localities/localitiesBangalore.json'))

localities.each do |locality|
  locality_name = locality["LOCATION"]
  Locality.create!(name: locality_name)
end

user_role = Role.create!(name: "user")
admin_role = Role.create!(name: "admin")

if Rails.env != 'production'
  60.times do
    name = Faker::Name.name
    email = Faker::Internet.email
    emp_id = Faker::Number.between(1111, 999999999)
    address = Faker::Address.street_address
    locality = Locality.all.sample
    phone_no = Faker::PhoneNumber.phone_number
    User.create!(name: name, email: email, emp_id: emp_id, address: address, locality: locality, phone_no: phone_no)
  end

  User.create!(id: 100, name: 'Deepika Srinivasa Iyengar Varadarajan', email: 'vdeepika@thoughtworks.com', emp_id: '18078', address: "Blah on Mars", locality: Locality.first, phone_no: "+91 9080706021", role: user_role)
  User.create!(id: 101, name: 'Sandeep Hegde', email: 'sandeeph@thoughtworks.com', emp_id: '18071', address: "Blah on Mars", locality: Locality.first, phone_no: "+91 9080706033", role: admin_role)

  current_localities = Locality.all
  current_cabpool_types = [:company_provided_cab, :external_cab, :personal_car]
  current_users = User.all
  current_users = current_users.reject { |user| user.id == 100 || user.id == 101 }

  number_of_cabpools = 11

  number_of_cabpools.times do
    timein = Faker::Time.between(2.days.ago, Time.now, :all)
    timeout = timein.advance(hours: 8)
    remarks = "Car - Indica.\nDriver - Manju.\nMob-9882373737"
    capacity_of_cabpool = Faker::Number.between(2, 4)
    built_localities = []
    built_users = []

    number_of_localities = Faker::Number.between(2, 4)

    number_of_localities.times do
      locality = current_localities.sample
      built_localities << locality
    end

    route = "{\"source\":\"#{built_localities[0].name} Bangalore, Karnataka \",\"destination\":{\"lat\":12.9287258,\"lng\":77.6267284},\"waypoints\":[]}"

    no_of_users_in_cabpool = Faker::Number.between(2, capacity_of_cabpool)

    no_of_users_in_cabpool.times do
      user = current_users.sample
      built_users << user
      current_users = current_users.reject { |u| u.name == user.name }
    end

    cabpool = Cabpool.new(timein: timein, timeout: timeout, number_of_people: capacity_of_cabpool, route: route, remarks: remarks, cabpool_type: current_cabpool_types.first)
    cabpool.localities = built_localities
    cabpool.users = built_users
    cabpool.save!
  end

  Request.create!(user_id: 1, cabpool_id: 1)
end