pcds-plc-routes
===============

Usage: ``./add_routes.sh hutch plc-hostname-match``

Examples
--------

``./add_routes.sh kfe plc-tmo-optics``
``./add_routes.sh tmo 'plc-tmo-*'``

Notes
-----

* ``ioc_hosts/{hutch}.txt`` should exist
* ``plc-hostname-match`` will be sent verbatim to 'netconfig'
* Script must be run from a host that can access the hutch's IOC hosts
