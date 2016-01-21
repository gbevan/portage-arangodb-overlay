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

    systemctl restart arangodb


Developer Notes:
----------------

* When releasing new ebuild, run:

        ebuild arangodb-2.7.x.ebuild manifest

  for your new ebuild version, then commit/push.
