portage-arangodb-overlay
========================

Gentoo Portage overlay for ArangoDB

/etc/layman/layman.cfg add:

    overlays: ...
              https://github.com/gbevan/portage-arangodb-overlay/raw/master/repository.xml

layman -a gbevan-arangodb

Developer Notes:

* When releasing new ebuild, run:

        ebuild arangodb-2.7.1.ebuild manifest

  for your new ebuild version, then commit/push.
