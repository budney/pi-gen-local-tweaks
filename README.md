# pi-gen-local-tweaks

This repo is meant to be installed under `pi-gen/stage2` in order
to build a custom raspberry pi image. This image has the following
customizations:

## Basic Configuration Stuff

* Bluetooth and WiFi are disabled
* A static ethernet IP is assigned to eth0
* ssh is enabled
* Locale and timezone are set for US / New York

## More Drastic Stuff

* A local DNS cache is installed using djbdns
* sSMTP is used to route outgoing email through Gmail
* Nightly backups are taken to a Samba volume and uploaded to dropbox
* Nightly unattended upgrades are enabled
* metricbeat is installed to send performance data to an elasticsearch node

## Minor Comforts

* Intial user is made a sudoer, but must use a password
* User must reset password on first login
* Home directory has its own ./tmp/ subdirectory
* User's ssh keys are pre-generated

That last item means that every system flashed from the same image
will have the same ssh keys. That would make it handy to set up a
bramble in which all the pi's interact with each other via ssh, but
it also has the obvious security issue that the private ssh key
will be available to everyone who has a copy of the image.

In other words, I'm assuming here that your images are intended for
private or internal use. You can, of course, make a separate image
for every machine you intend to flash. The benefit is that you have
the ability to reflash it to its original settings.

## Even More Drastic Stuff

The biggest feature of this repo is that it can install a working
copy of Elasticsearch on your pi out of the box. Getting elasticsearch
working is a miserable chore for many reasons, like:

* Lack of binaries for arm
* Building arm deb packages is practically impossible
* Broken java components like JNA
* The JRE for OpenJDK 11 has a classpath bug
* Being java-based, it has an insatiable lust for memory
* Settings must be tweaked because of the aforementioned

Etc., etc. That said, you should be aware that the elasticsearch
install does make a couple of assumptions about my personal hardware:
I use an external SSD for the data store, and its filesystem ID appears
in the `fstab`. Still, it should be pretty easy to spot those couple of
settings and tweak/remove them for your own images.

