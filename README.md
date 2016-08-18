# Search admin

The `search-admin` application manages search "best bets" and "recommended links" along with other search and browse data.

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

    `mysql> grant all on `search_admin\_%`.* to search_admin@localhost identified by 'search_admin';`


### Running the test suite

`bundle exec rake`

## Bulk load to rummager

In normal production use, whenever a modification is made in search-admin, any necessary corresponding updates are sent
to rummager.  However, if you need to load from scratch, or if you think an update has gone astray, you can bulk load data from the local database.

### Best bets

Create a dump of data that rummager should have, and the load it in to rummager, using:

    bundle exec ruby bin/export_best_bets_for_elasticsearch > ~/metasearch.dump
    cd /var/apps/rummager  # Or wherever rummager is installed
    bundle exec ruby bin/bulk_load metasearch < ~/metasearch.dump

### Recommended links

Run `bundle exec rake sync:recommended-links`

## Licence

[MIT License](LICENCE)
