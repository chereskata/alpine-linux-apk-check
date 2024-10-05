#! /bin/ash

rm -rf /tmp/flagged
mkdir /tmp/flagged
cd /tmp/flagged

# download flagged package list
i=1; while [ "$i" -le 20 ]
do
    wget "https://pkgs.alpinelinux.org/packages?page=${i}&name=&branch=edge&repo=&arch=x86_64&origin=yes&maintainer=&flagged=yes"
    i=$(( i + 1 ))
done
# filter the results regarding package names
cat *packages* | grep -A 1 -e "href=\"/package/" | sed -e "/href/d" -e "s/(\\t\| )*//g" | sort -u > outdated.txt

# gather installed packages
apk list -I | sed -e "s/.*{//" -e "s/}.*//" | sort -u > installed.txt

# build intersection to view installed packages, that are outdated
sort installed.txt outdated.txt | uniq -d > outdated_and_installed.txt
less outdated_and_installed.txt
