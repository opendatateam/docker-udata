# udata with gouvfr plugin and theme deployment with docker-compose

A sample docker-compose project with a customized udata deployment (enable the `gouvfr` plugin and theme)

```bash
$ docker-compose up -d
Creating network "gouvfr_default" with the default driver
Creating volume "gouvfr_udata-fs" with default driver
Creating volume "gouvfr_mongo-data" with default driver
Creating volume "gouvfr_redis-data" with default driver
Creating volume "gouvfr_elasticsearch-data" with default driver
Creating gouvfr_mongodb_1
Creating gouvfr_elasticsearch_1
Creating gouvfr_redis_1
Creating gouvfr_udata_1
$ docker-compose run --rm udata init
-> Initialize or update ElasticSearch mappings
-> Build sample fixture data
-> Generated admin user "user@udata" with password "password".
-> A team and an organization were generated for "user@udata".
-> 10 new datasets 5 reuses were generated.
-> 2 new licences were generated.
-> Apply DB migrations if needed
-> udata:2015-05-06-migrate-issues.js ................................... [Recorded]
-> udata:2015-06-10-public-service-to-badges.js ......................... [Recorded]
-> udata:2015-08-19-migrate-resource-published.js ....................... [Recorded]
-> udata:2015-09-14-generic-badges.js ................................... [Recorded]
-> udata:2015-09-23-community-resources.js .............................. [Recorded]
-> udata:2015-09-25-migrate-harvest-sources-validation.js ............... [Recorded]
-> udata:2015-10-08-migrate-resources-field-names.js .................... [Recorded]
-> udata:2015-10-19-deduplicate-badges.js ............................... [Recorded]
-> udata:2015-11-16-remove-supplier.js .................................. [Recorded]
-> udata:2015-11-23-set-uuid-as-community-resources-id.js ............... [Recorded]
-> udata:2015-12-09-generic-references.js ............................... [Recorded]
-> udata:2016-01-12-add-tag-slug.js ..................................... [Recorded]
-> udata:2016-01-21-set-uuid-for-community-resources.js ................. [Recorded]
-> udata:2016-01-21-set-uuid-for-resources.js ........................... [Recorded]
-> udata:2016-01-25-fix-resources-checksums.js .......................... [Recorded]
-> udata:2016-02-03-clean-topic-datasets.js ............................. [Recorded]
-> udata:2016-03-02-fix-resources-checksums.js .......................... [Recorded]
-> udata:2016-11-08-truncate-tags.js .................................... [Recorded]
-> udata:2016-11-28-deduplicate-users.js ................................ [Recorded]
-> udata:2016-11-29-confirm-active-users.js ............................. [Recorded]
-> udata:2016-12-20-dublin-core-frequencies.js .......................... [Recorded]
-> udata:2017-01-05-geozones-admin-levels.js ............................ [Recorded]
-> udata:2017-02-23-references-indexes.js ............................... [Recorded]
-> udata:2017-02-25-missing-user-metrics.js ............................. [Recorded]
-> udata:2017-04-24-fix-resources-urls.js ............................... [Recorded]
```
