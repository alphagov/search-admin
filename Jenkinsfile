#!/usr/bin/env groovy

library("govuk")

node {
  // Use GOV.UK CI's Docker instance of MySQL 8
  govuk.setEnvar("TEST_DATABASE_URL", "mysql2://root:root@127.0.0.1:33068/search_admin_test")
  govuk.buildProject()
}
