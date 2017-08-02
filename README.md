# portage-arangodb-overlay

## Gentoo Portage overlay for ArangoDB (v3)

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

## Upgrading

    layman -s gbevan-arangodb
    emerge -v -u arangodb3

Ensure all active connections, from applications and arangosh etc, are shutdown/closed before restarting:

    systemctl daemon-reload
    systemctl restart arangodb3

Check the logs:

    journalctl -b -u arangodb3

If you get message like:

    FATAL Database 'partout' needs upgrade. Please start the server with the --upgrade option

then:

    arangod --uid arangodb --gid arangodb --upgrade

## Upgrading from v3.1 to v3.2

If you get error in `/var/log/arangodb3/arangod.log`:

    2017-08-02T20:20:42Z [17223] ERROR In database '_system': Database directory version (30126) is lower than current version (30200).
    2017-08-02T20:20:42Z [17223] ERROR In database '_system': ----------------------------------------------------------------------
    2017-08-02T20:20:42Z [17223] ERROR In database '_system': It seems like you have upgraded the ArangoDB binary.
    2017-08-02T20:20:42Z [17223] ERROR In database '_system': If this is what you wanted to do, please restart with the
    2017-08-02T20:20:42Z [17223] ERROR In database '_system':   --database.auto-upgrade true
    2017-08-02T20:20:42Z [17223] ERROR In database '_system': option to upgrade the data in the database directory.
    2017-08-02T20:20:42Z [17223] ERROR In database '_system': Normally you can use the control script to upgrade your database
    2017-08-02T20:20:42Z [17223] ERROR In database '_system':   /etc/init.d/arangodb stop
    2017-08-02T20:20:42Z [17223] ERROR In database '_system':   /etc/init.d/arangodb upgrade
    2017-08-02T20:20:42Z [17223] ERROR In database '_system':   /etc/init.d/arangodb start
    2017-08-02T20:20:42Z [17223] ERROR In database '_system': ----------------------------------------------------------------------
    2017-08-02T20:20:42Z [17223] FATAL Database '_system' needs upgrade. Please start the server with the --database.auto-upgrade option
    2017-08-02T20:20:42Z [17223] FATAL Database '_system' upgrade failed. Please inspect the logs from the upgrade procedure

You will have to upgrade the database using:

    /usr/sbin/arangod --pid-file /var/run/arangod3/arangod.pid --server.uid arangodb3 --database.auto-upgrade true

And then try restarting again.

## Upgrading from v2 to v3

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


## Developer Notes:

* When releasing new ebuild, run:

        ebuild arangodb3-3.x.x.ebuild manifest

  for your new ebuild version, then commit/push.
