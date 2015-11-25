10.times do
  locality_name = Faker::Address.street_name
  Locality.create!(name: locality_name)
end

