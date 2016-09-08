portage-arangodb-overlay
========================

Gentoo Portage overlay for ArangoDB
-----------------------------------

[ArangoDB - the multi-model NoSQL database](https://www.arangodb.com/).

/etc/layman/layman.cfg add:

    overlays: ...
              https://github.com/gbevan/portage-arangodb-overlay/raw/master/repository.xml

run:

    layman -f -a gbevan-arangodb
    emerge -v --ask arangodb3

to start (systemd):

    systemctl enable arangodb3
    systemctl start arangodb3

(pre-systemd init scripts are also provided - let me know if you have any issues/fixes)

Upgrading v2 -> v3
---------

The ebuild for v3 now working, but read the following carefully:

__VERY IMPORTANT: If upgrading from v2.\* to v3.\* - read the ArangoDB docs.  The database format has changed to use VelocityPack, and is not compatible with the 2.* version database.  See: https://docs.arangodb.com/3.0/Manual/Administration/Upgrading/Upgrading30.html__

(Assuming you have read and are following the above migration instructions...)

You will have to uninstall arangodb v2 prior to installing arangodb3

    systemctl stop arangodb
    emerge --unmerge arangodb
    emerge -v arangodb3
    systemctl start arangodb3

if you get error:

    2016-07-21T19:44:17Z [19412] INFO JavaScript using startup 'share/arangodb3/js', application '/var/lib/arangodb3-apps'
    2016-07-21T19:44:17Z [19412] ERROR cannot locate file 'server/initialize.js': No such file or directory
    2016-07-21T19:44:17Z [19412] ERROR unknown script 'server/initialize.js'
    2016-07-21T19:44:17Z [19412] FATAL cannot load JavaScript file 'server/initialize.js'
    2016-07-21T19:44:17Z [19412] ERROR cannot locate file 'server/initialize.js': No such file or directory
    2016-07-21T19:44:17Z [19412] ERROR unknown script 'server/initialize.js'
    2016-07-21T19:44:17Z [19412] FATAL cannot load JavaScript file 'server/initialize.js'

edit ```/etc/arangodb3/arangod.conf```

    startup-directory = /usr/share/arangodb3/js
                        ^^^^^ <- add this to path

repeat for ```/etc/arangodb3/arangosh.conf```


Upgrading (v2 instructions for now)
---------

    layman -s gbevan-arangodb
    emerge -v -u arangodb

Ensure all active connections, from applications and arangosh etc, are shutdown/closed before restarting:

    systemctl daemon-reload
    systemctl restart arangodb

Check the logs:

    journalctl -b -u arangodb

If you get message like:

    FATAL Database 'partout' needs upgrade. Please start the server with the --upgrade option

then:

    arangod --uid arangodb --gid arangodb --upgrade
    (there may be an upgrade option via systemctl... maybe...)


Developer Notes:
----------------

* When releasing new ebuild, run:

        ebuild arangodb3-3.x.x.ebuild manifest

  for your new ebuild version, then commit/push.
