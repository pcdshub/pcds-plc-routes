pcds-plc-routes
===============

## Requirements

* The script must be run from a host that can access the hutch's IOC hosts!
* The user must have SSH access to all of the IOC hosts.

## Installation

```bash
$ git clone https://github.com/pcdshub/pcds-plc-routes
$ cd pcds-plc-routes
$ ./add_routes.sh
```

## Usage

Usage: ``./add_routes.sh hutch plc-hostname-match``

### Examples

1. To add all KFE hosts to plc-tmo-optics, run:
   ```bash
   $ ./add_routes.sh kfe plc-tmo-optics
   ```
   
2. To add all TMO hosts to any PLC that matches "plc-tmo-*" (according to netconfig):
   ```
   $ ./add_routes.sh tmo 'plc-tmo-*'
   ```

### Important Notes

* IOC hosts come from``ioc_hosts/{hutch}.txt``.
    * For example, specifying ``./add_routes.sh kfe`` will use hosts in ``ioc_hosts/kfe.txt``.
* ``plc-hostname-match`` will be sent verbatim to `netconfig`
    * To match a single PLC hostname, type the full hostname for this argument.
    * To match multiple PLC hostnames, use "glob" syntax
* ads-async assumes that either the default credentials will work, or environment variables were set before running ``add_routes.sh``.
    * To change PLC credentials, use ``ADS_ASYNC_USERNAME`` and ``ADS_ASYNC_PASSWORD`` ([per its source code](https://github.com/pcdshub/ads-async/blob/e23947c70eb3b899989b423c2548b49d1663eb1b/ads_async/constants.py#L24-L25))

## How it works

* ``pcds-plc-routes`` contains a list of IOC hosts that are commonly used in ``ioc_hosts/``
* To add a route, the PLC must see a UDP packet come from the host
* As such, the script will `ssh` to each of these hosts to send that packet
* The library [``ads-async``](https://github.com/pcdshub/ads-async) is used to generate the "add route" request


## What does "good" output look like?

```bash
$ ./add_routes.sh las plc-las-opcpa-eps-01
* IOC host: ctl-las-ftl-srv01 (172.21.161.21) Net ID: 172.21.161.21.1.1

+ for plc in plc-las-opcpa-eps-01
+ ads-async route --route-name=ctl-las-ftl-srv01 plc-las-opcpa-eps-01 172.21.161.21.1.1 172.21.161.21
{
    "command_id": 6,
    "source_net_id": "172.21.160.250.1.1",
    "source_ams_port": 10000,
    "source_addr": [
        "172.21.160.250",
        48899
    ],
    "unknown_response_id": 1,
    "password_correct": true,
    "authentication_error": false
}
```
