#!/bin/bash
if [ ! -d "/usr/local/share/GeoIP" ]; then
mkdir -p /usr/local/share/GeoIP
fi
cd /usr/local/share/GeoIP
if [ -f "/usr/local/share/GeoIP/GeoLite2-City.tar.gz" ]; then
rm /usr/local/share/GeoIP/GeoLite2-City.tar.gz
fi
wget https://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz
if [ -f "/usr/local/share/GeoIP/GeoLite2-City.mmdb" ]; then
rm /usr/local/share/GeoIP/GeoLite2-City.mmdb
fi
tar xzf GeoLite2-City.tar.gz --strip=1
if [ -f "/usr/local/share/GeoIP/GeoLite2-Country.tar.gz" ]; then
rm /usr/local/share/GeoIP/GeoLite2-Country.tar.gz
fi
wget https://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz
if [ -f "/usr/local/share/GeoIP/GeoLite2-Country.mmdb" ]; then
rm /usr/local/share/GeoIP/GeoLite2-Country.mmdb
fi
tar xzf GeoLite2-Country.tar.gz --strip=1