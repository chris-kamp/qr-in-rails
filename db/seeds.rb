Business.destroy_all

User.destroy_all
Category.destroy_all

user = User.create(
  email: "foo@bar.com",
  password: "password",
  username: "foo",
  public: true,
  bio: "Hi, I'm a user"
)

bar = Category.create(
  name: "Bar"
)

address = Address.create(
  street: "123 Coder Street",
  postcode: Postcode.create(code: 4000),
  state: State.create(name: "QLD"),
  suburb: Suburb.create(name: "Brisbane City"),
  business: User.first.create_business(
    category: bar,
    name: 'some business',
    description: "It's a business",
    address: address
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
