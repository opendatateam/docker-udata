#!/bin/bash
set -e
case $1 in
    uwsgi)
        udata collect -ni /udata/public
        uwsgi --emperor /udata/uwsgi/
        ;;
    front)
        uwsgi /udata/uwsgi/front.ini
        ;;
    worker)
        uwsgi /udata/uwsgi/worker.ini
        ;;
    beat)
        uwsgi /udata/uwsgi/beat.ini
        ;;
    celery)
        celery -A udata.worker "${@:2}"
        ;;
    bash)
        /bin/bash
        ;;
    *)
        udata "$@"
        ;;
esac
