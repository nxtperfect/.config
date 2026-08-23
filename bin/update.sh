#!/bin/sh
emaint -a sync
emerge -avuDN @world
emerge --depclean
flatpak update
guix pull
eclean-kernel -n 3
