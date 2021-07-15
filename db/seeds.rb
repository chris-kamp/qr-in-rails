User.destroy_all
Business.destroy_all
Category.destroy_all

users =
  User.create(
    [
      {
        email: 'user1@user1.com',
        password: 'password',
        username: 'user1',
        public: true,
        bio: "Hi, I'm the first user",
      },
      {
        email: 'user2@user2.com',
        password: 'password',
        username: 'user2',
        public: false,
        bio: "Hi, I'm the second user",
      },
    ],
  )

categories =
  Category.create([{ name: 'Bar' }, { name: 'Restaurant' }, { name: 'Cafe' }])

address =
  Address.create(
    street: '123 Coder Street',
    postcode: Postcode.create(code: 4000),
    state: State.create(name: 'QLD'),
    suburb: Suburb.create(name: 'Brisbane City'),
    business:
      users[0].create_business(
        category: categories[0],
        name: 'some business',
        description: "It's a business",
      ),
  )

Checkin.create(user: User.first, business: Business.first)

Review.create(user: User.first, business: Business.first, rating: 5)
Review.create(user: users[1], business: Business.first, rating: 3, content: "Hi, I'm a review")
