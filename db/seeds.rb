User.destroy_all
Business.destroy_all
Category.destroy_all

users =
  User.create(
    [
      {
        email: 'user1@user1.com',
        password: 'Password1',
        username: 'user1',
        public: true,
        bio: "Hi, I'm the first user",
      },
      {
        email: 'user2@user2.com',
        password: 'Password1',
        username: 'user2',
        public: false,
        bio: "Hi, I'm the second user",
      },
      {
        email: 'user3@user3.com',
        password: 'Password1',
        username: 'user3',
        public: true,
        bio: "Hi, I'm the third user",
      },
      {
        email: 'user4@user4.com',
        password: 'Password1',
        username: 'user4',
        public: false,
        bio: "Hi, I'm the fourth user",
      },
    ],
  )

categories =
  Category.create([{ name: 'Bar' }, { name: 'Restaurant' }, { name: 'Cafe' }])

businesses =
  Business.create(
    [
      {
        user: users[0],
        category: categories[0],
        name: 'First business',
        description: "It's the first business",
        address:
          Address.create(
            street: '123 Coder Street',
            postcode: Postcode.create(code: 4000),
            state: State.create(name: 'Queensland'),
            suburb: Suburb.create(name: 'Brisbane City'),
          ),
      },
      {
        user: users[1],
        category: categories[1],
        name: "Second business",
        description: "It's the second business",
        address:
          Address.create(
            street: "456 Fake Street",
            postcode: Postcode.create(code: 1234),
            state: State.create(name: "New South Wales"),
            suburb: Suburb.create(name: "Sydney")
          )
      }
    ],
  )

businesses[0].checkins.create(user: users[3], review: Review.create(rating: 3, content: "Extremely average"))
businesses[0].checkins.create(user: users[2], review: Review.create(rating: 5, content: "Great"))
businesses[0].checkins.create(user: users[1])
businesses[1].checkins.create(user: users[3], review: Review.create(rating: 4, content: "Pretty okay"))
businesses[1].checkins.create(user: users[2], review: Review.create(rating: 5))
businesses[1].checkins.create(user: users[0], review: Review.create(rating: 1, content: "Not great"))
