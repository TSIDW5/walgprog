namespace :db do
  desc 'Erase and Fill database'
  task populate: :environment do
    [Contact].each(&:delete_all)

    10.times do
      Contact.create!(
        name: Faker::Name.unique.name,
        email: Faker::Internet.email,
        phone: Faker::PhoneNumber.cell_phone,
        institution: Institution.all.sample
      )
    end
  end
end