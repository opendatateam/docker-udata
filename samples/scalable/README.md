# Scalable udata deployment with docker-compose

A sample docker-compose project which front and worker services can be scaled independently.

It uses <https://github.com/jwilder/nginx-proxy> as reverse proxy to allow
front scaling with dynamic upstream update (uses [docker-gen][] to update upstream declaration).

```bash
# Start services in background
$ docker-compose up -d
Creating network "scalable_default" with the default driver
Creating volume "scalable_udata-fs" with default driver
Creating volume "scalable_mongo-data" with default driver
Creating volume "scalable_redis-data" with default driver
Creating volume "scalable_elasticsearch-data" with default driver
Creating scalable_mongodb_1
Creating scalable_elasticsearch_1
Creating scalable_nginx_1
Creating scalable_redis_1
Creating scalable_beat_1
Creating scalable_front_1
Creating scalable_udata_1
Creating scalable_worker_1
$ docker-compose ps
          Name                        Command               State                 Ports               
-----------------------------------------------------------------------------------------------------
scalable_beat_1            /udata/entrypoint.sh beat        Up       7000/tcp, 7001/tcp               
scalable_elasticsearch_1   /docker-entrypoint.sh elas ...   Up       0.0.0.0:9200->9200/tcp, 9300/tcp
scalable_front_1           /udata/entrypoint.sh front       Up       7000/tcp, 7001/tcp               
scalable_mongodb_1         docker-entrypoint.sh mongod      Up       0.0.0.0:27017->27017/tcp         
scalable_nginx_1           /app/docker-entrypoint.sh  ...   Up       0.0.0.0:7000->80/tcp             
scalable_redis_1           docker-entrypoint.sh redis ...   Up       0.0.0.0:6379->6379/tcp           
scalable_udata_1           /udata/entrypoint.sh colle ...   Exit 0                                    
scalable_worker_1          /udata/entrypoint.sh worker      Up       7000/tcp, 7001/tcp
# Initialize UData
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
# Scale frontend services to 2 instances
$ docker-compose scale front=2
Creating and starting scalable_front_2 ... done
# Scale worker services to 3 instances
$ docker-compose scale worker=3
Creating and starting scalable_worker_2 ... done
Creating and starting scalable_worker_3 ... done
# Docker containers are instanciated
$ docker-compose ps
          Name                        Command               State                 Ports               
-----------------------------------------------------------------------------------------------------
scalable_beat_1            /udata/entrypoint.sh beat        Up       7000/tcp, 7001/tcp               
scalable_elasticsearch_1   /docker-entrypoint.sh elas ...   Up       0.0.0.0:9200->9200/tcp, 9300/tcp
scalable_front_1           /udata/entrypoint.sh front       Up       7000/tcp, 7001/tcp               
scalable_front_2           /udata/entrypoint.sh front       Up       7000/tcp, 7001/tcp               
scalable_mongodb_1         docker-entrypoint.sh mongod      Up       0.0.0.0:27017->27017/tcp         
scalable_nginx_1           /app/docker-entrypoint.sh  ...   Up       0.0.0.0:7000->80/tcp             
scalable_redis_1           docker-entrypoint.sh redis ...   Up       0.0.0.0:6379->6379/tcp           
scalable_udata_1           /udata/entrypoint.sh colle ...   Exit 0                                    
scalable_worker_1          /udata/entrypoint.sh worker      Up       7000/tcp, 7001/tcp               
scalable_worker_2          /udata/entrypoint.sh worker      Up       7000/tcp, 7001/tcp               
scalable_worker_3          /udata/entrypoint.sh worker      Up       7000/tcp, 7001/tcp  
# NGinx configuration is updated
$ docker-compose exec nginx cat /etc/nginx/conf.d/default.conf

...
# localhost
upstream localhost {
				## Can be connect with "scalable_default" network
			# scalable_front_2
			server 172.22.0.9:7000;
				## Can be connect with "scalable_default" network
			# scalable_front_1
			server 172.22.0.7:7000;
}
server {
	server_name localhost;
	listen 80 ;
	access_log /var/log/nginx/access.log vhost;
	location / {
		proxy_pass http://localhost;
	}
}

$ docker-compose run --rm udata celery status
celery@a717c6803e06: OK
celery@665ff34c2d69: OK
celery@1f8465943b82: OK

3 nodes online.
```

You can override the reverse-proxied name with the `VIRTUAL_HOST` environment variable.
(Keep in mind that you also need to update the `udata.cfg` configuration file)

```shell
VIRTUAL_HOST=foo.bar.org docker-compose up
```

You can execute `udata` commands with the `udata` service container:

```
docker-compose run --rm udata --help
```

[docker-gen]: https://github.com/jwilder/docker-gen
