#!/bin/bash
echo "creating changelog for: vdr-plugin-vnsiserver"
cd debian
package="vdr-plugin-vnsiserver"
dist=$(awk '/xbmc-pvr-vdr-vnsi/ {gsub(";",""); print $3'} changelog)
tag=$(awk '/[0-9]-([0-9]+)~/ {match($2, "[0-9]-([0-9]+)~",a)} END{print a[1]}' changelog)

version="1:"$(awk -F'=' '/\*VERSION/ {gsub("\"",""); gsub(" ",""); gsub(";",""); print $2}' ../vdr-plugin-vnsiserver/vnsi.h)"-${tag}~${dist}"
echo "${version}" > ${package}.version

dch -c ${package}.changelog --create --empty --package vdr-plugin-vnsiserver -v"${version}" --distribution ${dist} --force-distribution 2>/dev/null "no upstream changelog available"

awk '/xbmc-pvr-vdr-vnsi/ {gsub("\\(",""); gsub("\\)",""); print $2}' changelog > xbmc-pvr-vdr-vnsi.version

cd ..
