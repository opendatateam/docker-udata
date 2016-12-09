#!/bin/bash
case $1 in
    uwsgi)
        udata collect -ni /udata/public && uwsgi --emperor /udata/uwsgi/
        ;;
    bash)
        /bin/bash
        ;;
    *)
        udata "$@"
        ;;
esac
$CMD
