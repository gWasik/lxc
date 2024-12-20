#!/bin/bash
if nc -w1 -z "apt-cacher-ng.lan" 3142; then
  echo -n "http://apt-cacher-ng.lan:3142"
else
  echo -n "DIRECT"
fi