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
3. The number of events in the future will be much greater than the number of unique actions to be performed on those events.
   Hence, I chose to implement the assignment with actions-on-the-events based approach rather than individual-event based approach.
4. User's details are available on iterable.com to configure template for sending emails.

# Extending code to add another external event publisher
To add another external publisher, you need to do the following changes:
1. Add the API library for the new service in the `app/lib/api/` directory. You can refer to the `app/lib/api/iterable` code.
2. Add a new service class in `/app/services/user_engagement_service/event_publishers` directory and override the following methods as required:
  1. `publish_event!`
  2. `send_email_for_event_id?`
  3. `send_email_for_event_id!`
  4. `platform`
3. Add the name of the new class(created in the above step) to the `UserEngagementService.external_event_publishers` method.

# Database schema
## Tables
### users
| Column Name | Column Type |
|:------------|:------------|
| id          | uuid        |
| first_name  | string      |
| last_name   | string      |
| email       | string      |

### events
| Column Name  | Column Type |
|:-------------|:------------|
| id           | uuid        |
| name         | string      |
| user_id      | uuid        |
| other_fields | jsonb       |

### published_events
| Column Name   | Column Type |
|:--------------|:------------|
| id            | uuid        |
| event_id      | uuid        |
| platform      | string      |
| published_at  | datetime    |
| api_responses | jsonb       |

## Associations
- 1 user has many events
- 1 event can be published to multiple destinations/services.

# Tasks
  * [x] Mock APIs of iterable.com w.r.t tracking events, creating/updating users and sending emails.
  * [x] UI for a single user to click 2 buttons.
  * [x] Push the events to iterable.com and our database.
  * [x] On event B, send an email to the user using iterable.com's API.
  * [x] Persist data across restarts.
  * [ ] Bonus: User Management
  * [ ] Bonus: Authentication
