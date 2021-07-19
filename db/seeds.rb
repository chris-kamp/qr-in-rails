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
        name: 'Example business',
        description: "It's a business",
      ),
  )

Business.create(
  user: users[1],
  address: Address.create(
    street: '456 Coder Street',
    postcode: Postcode.create(code: 5555),
    state: State.create(name: 'NSW'),
    suburb: Suburb.create(name: 'Sydney')
  ),
  category: categories[1],
  name: 'This is another example business',
  description: 'Another example business with a much longer description.  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras mollis nisi scelerisque nunc volutpat tincidunt. Nulla fermentum in nibh eu placerat. Phasellus laoreet mollis nisl nec egestas. Suspendisse mollis, tortor non tempor aliquam, lectus dui tempor ante, sit amet pretium libero sem ut sapien. Maecenas a leo sed ipsum eleifend ornare id sollicitudin nunc. Pellentesque id venenatis arcu. In ornare eu urna vitae pretium. Praesent accumsan, lorem vitae auctor pretium, metus dolor fringilla urna, eget accumsan sem odio sed velit. Aenean congue dui posuere nisi elementum, et lobortis lectus placerat. Nulla facilisi. Proin at risus mi. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean ut pulvinar ipsum. Mauris gravida in nisi sed blandit.'
)

Checkin.create(user: User.first, business: Business.first)

Review.create(user: User.first, business: Business.first, rating: 5)
Review.create(user: users[1], business: Business.first, rating: 3, content: "Hi, I'm a review")
