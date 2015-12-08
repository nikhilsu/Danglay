  Locality.create!(name: 'Mars')

20.times do
  locality_name = Faker::Address.street_name
  Locality.create!(name: locality_name)
end

20.times do
  name = Faker::Name.name
  email = Faker::Internet.email
  emp_id = Faker::Number.number(5)
  address = Faker::Address.street_address
  locality = Locality.all.sample
  User.create!(name: name, email: email, emp_id: emp_id, address: address, locality: locality)
end
User.create!(name: 'Deepika', email: 'vdeepika@thoughtworks.com', emp_id: '18078', address: "Blah on Mars", locality: Locality.first )

2.times do
  timein = Faker::Time.between(2.days.ago, Time.now, :all)
  timeout = Faker::Time.between(2.days.ago, Time.now, :all)
  number_of_people = 4

  localities = []
  2.times do
    locality = Locality.all.sample
    localities << locality if !localities.include? locality
  end

  users = []
  2.times do
    user = User.all.sample
    users << user if !users.include? user
  end

  cabpool = Cabpool.new(timein: timein, timeout: timeout, number_of_people: number_of_people)
  cabpool.localities = localities
  cabpool.users = users
  cabpool.save!
end
