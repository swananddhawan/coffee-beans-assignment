# Setup
1. Install Ruby version `3.0.0`. You may refer to https://rvm.io/rvm/install for installation.
2. Install Postgres version `12.5`. Stick to the major version of `12` for not having undesired effect. You can refer to https://www.postgresql.org/download/ for installation.
3. Install Redis if not installed. You can refer to https://redis.io/docs/install/install-redis/ for installation.
4. Start the redis server as a background job:
   ``` shell
   redis-server 2> /dev/null > /dev/null &
   ```

5. Install Rails version `7.1.3.2` using the following command:
   ```shell
   gem install rails -v '7.1.3.2'
   ```

6. Inside the root of the project directory, initiate the installation of the gems:
   ``` shell
   bundle install
   ```

7. Setup the database for the first time using:
   ``` shell
   bundle exec rails db:setup
   ```

8. Start Rails server using:
   ``` shell
   bundle exec rails server
   ```

9. Start Sidekiq process:
   ``` shell
   bundle exec sidekiq
   ```

10. Open http://127.0.0.1:3000/ in your browser to open the index page.

# Running test suite
Execute the following command in the root directory

``` shell
bundle exec rspec spec/
```

# Assumptions
1. API will always send a non-empty JSON request body to iterable.com.
2. Our project is ![UserID-based project](https://support.iterable.com/hc/en-us/articles/204780579-API-Overview-and-Sample-Payloads#identifying-users), hence we will always work with `userId` and not `email`.
3. TODO: Number of events >>> actions to be performed on events
