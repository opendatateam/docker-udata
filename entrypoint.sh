#!/bin/bash
set -e

if [ "$(ls -A /src)" ]; then
    # Install packages from requirements files
    for r in /src/*/requirements/*.pip ; do
        echo "Installing dependencies from $r"
        pip install -r "$r"
    done
    # Install source repositories as editable
    # (must happen after dependencies to allow for overrides)
    for d in /src/*/ ; do
        echo "Installing $d"
        pip install -e "$d"
    done
fi

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
