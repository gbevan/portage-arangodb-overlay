portage-arangodb-overlay
========================

Gentoo Portage overlay for ArangoDB
-----------------------------------

[ArangoDB - the multi-model NoSQL database](https://www.arangodb.com/).

/etc/layman/layman.cfg add:

    overlays: ...
              https://github.com/gbevan/portage-arangodb-overlay/raw/master/repository.xml

layman -f -a gbevan-arangodb

emerge -v --ask arangodb


Upgrading
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

        ebuild arangodb-2.8.x.ebuild manifest

  for your new ebuild version, then commit/push.
