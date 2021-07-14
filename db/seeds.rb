# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
Category.destroy_all
Business.destroy_all

user = User.create(
    email: "foo@bar.com",
    password_digest: "password",
    username: "foo",
    bio: "text",
    public: "true"
)

category = Category.create(
    name: "foo"
)

business = Business.create(
    category_id: category.id,
    user_id: user.id,
    name: "foo",
    description: "foobar",
    address: Address.create(
        street: "20",
        state_id: State.create(
            name: "foobar"
        ),
        postcode_id: Postcode.create(
            code: 2020
        ),
        suburb_id: Suburb.create(
            name: "foobar"
        )
    )
)

Checkin.create(
    user: user,
    business: business
)

Review.create(
    user: user,
    business: business,
    rating: 5
)