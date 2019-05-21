#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )";

rm -f /var/run/supervisor.pid
rm -f /var/run/supervisor.sock
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf