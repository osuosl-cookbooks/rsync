1.0.2 (2016-07-05)
------------------
- Add matchers for the rsync_serve LWRP

v1.0.0 (2015-05-12)
-------------------
- Convert LWRP to a library
- Allow ability to not start rsync service if being used with xinetd

v0.8.6 (2014-09-30)
-------------------
- [#11] Fixes to allow rsync daemon to be started if not up.

v0.8.4
------
### Improvement
- **[COOK-3580](https://tickets.chef.io/browse/COOK-3580)** - Add Test Kitchen, Specs, and Travis CI


v0.8.2
------
### Improvement
- **[COOK-3153](https://tickets.chef.io/browse/COOK-3153)** - Add `refuse_options` parameter to `rsync_serve`

### Bug
- **[COOK-2874](https://tickets.chef.io/browse/COOK-2874)** - Support chkconfig
- **[COOK-2873](https://tickets.chef.io/browse/COOK-2873)** - Allow setting value to false in `rsyncd.conf`

v0.8.0
------
* [COOK-878] - Add LWRP for rsyncd.conf and server recipe

v0.7.0
------
* Initial released version
