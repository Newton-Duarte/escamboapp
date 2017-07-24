namespace :utils do
  desc "Criar administrators fake"
  task generate_admins: :environment do

    puts "Gerando administrators Fakes..."

    10.times do
      Admin.create!(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password: "123456",
        password_confirmation: "123456"
        )
    end

    puts "Gerando administrators Fakes...[OK]"

  end

end
