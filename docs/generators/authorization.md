## Authorization

If the app requires authorization for users, you can configure it
by running

```bash
rails g tealeaves:authorization
```

Authorization is handled by the `action_policy` gem. It is very similar in its function
to `Pundit` but provides additional functionality. It is very easy to swap out however.
Full documentation on ActionPolicy can be found [here](https://actionpolicy.evilmartians.io)

