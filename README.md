# Rate Limiter App

This app contains a simple Rate Limiter

* There are 2 options for caches. A hash (default) stores the data in an in memory hash. A DB backed cache stores the data in the database. These can be configured in application.rb. A future addition would be to add a Redis cache as an option.

* The system allows a specific IP address to hit the site 100 times per hour before being rate limited. This is calculated on the clock hour. If, for example, a user hits the site 100 times at 11:59, the user will be able to hit the site again at 12:00. A rolling rate limiter would be much less performant (storing every hit by every user). This solution allows a user to hit the site a maximum of 200 times within a 60 minute period. This is acceptable for most use cases.

* This does create one potential problem. If a site is being ddosed and all bots get limited, this solution means that they would all get unblocked at the turn of the hour; creating a sudden, very high load. Consequently, this is not recommended for actual DDOS protection.

* To run:
```bash
> bundle install
> bundle exec rake db:migrate
> bundle exec rails s
```

* To run the tests
```bash
> bundle exec rspec
```
