## Authentication

If the app requires authentication, you can install it by running

```bash
rails g tealeaves:authentication
```

This will create a User model if one doesn't already exist, and setup the `Clearance`
gem. As well as this, it will generate the default set of routes provided by Clearance,
which includes

- password reset
- sign in and out
- user management (configurable)
- registration

Please adjust these as needed.
