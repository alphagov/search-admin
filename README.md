# Search admin

The `search-admin` application manages search "best bets" and "recommended links" along with other search and browse data.

## Screenshots

![Search Admin](docs/images/screenshot.png)

## Live example

- https://search-admin.publishing.service.gov.uk/

## Technical documentation

This is a Ruby on Rails application that manages search "best bets" and "recommended links" along with other search and browse data. It is behind the signon authentication system and doesn't have a public API.

### Dependencies

- [alphagov/rummager](https://github.com/alphagov/rummager) - search-admin sends updates to rummager when best bets and recommended links are edited

### Running the application

`./startup.sh`

The app runs on port 3073. If you're using the dev VM it will be available at http://search-admin.dev.gov.uk/

#### Creating the mysql user

The database.yml for this project is checked into source control so
you'll need a local user with credentials that match those in
database.yml.

    mysql> grant all on `search_admin\_%`.* to search_admin@localhost identified by 'search_admin';

### Running the test suite

`bundle exec rake`

### Recommended links

Run `bundle exec rake publish_recommended_links` to send all recommended links to Rummager.

## Licence

[MIT License](LICENSE)
