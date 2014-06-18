# Search admin

The `search-admin` application manages search "best bets" along with other
search and browse data.

## Creating the mysql user

The database.yml for this project is checked into source control so
you'll need a local user with credentials that match those in
database.yml.

    mysql> grant all on `search_admin\_%`.* to search_admin@localhost identified by 'search_admin';

## Bulk load to rummager

In normal production use, whenever a modification is made in search-admin, any necessary corresponding updates are sent to rummager.  However, if you need to load from scratch, or if you think an update has gone astray, you can create a dump of data that rummager should have, and the load it in to rummager, using:

    bundle exec ruby bin/export_best_bets_for_elasticsearch > ~/metasearch.dump
    cd /var/apps/rummager  # Or wherever rummager is installed
    bundle exec ruby bin/bulk_load metasearch < ~/metasearch.dump
