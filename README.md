# Search admin

Manages search "best bets" and "external links" along with other search and browse data.

## Screenshots

![Search Admin](docs/images/screenshot.png)

## Live example

- https://search-admin.publishing.service.gov.uk/

## Technical documentation

This is a Ruby on Rails app, and should follow [our Rails app conventions](https://docs.publishing.service.gov.uk/manual/conventions-for-rails-applications.html).

You can use the [GOV.UK Docker environment](https://github.com/alphagov/govuk-docker) to run the application and its tests with all the necessary dependencies. Follow [the usage instructions](https://github.com/alphagov/govuk-docker#usage) to get started.

**Use GOV.UK Docker to run any commands that follow.**

### Running the test suite

`bundle exec rake`

### External links

Run `bundle exec rake publish_external_links:publishing_api` to send all external links to the publishing API.

## Licence

[MIT License](LICENSE)
