#! /bin/ash

rm -rf /tmp/umaint
mkdir /tmp/umaint
cd /tmp/umaint

# download flagged package list
i=1; while [ "$i" -le 35 ]
do
    wget "https://pkgs.alpinelinux.org/packages?maintainer=None&page=${i}&branch=edge&arch=x86_64"
    i=$(( i + 1 ))
done

cat *packages* | grep -A 1 -e "<td class=\"package\">" | grep hint--right | sed -e "s/ *<.*\">//" -e "s/<.*> *//" | sort -u > unmaintained.txt

# gather installed packages
apk list -I | sed -e "s/.*{//" -e "s/}.*//" | sort -u > installed.txt

# build intersection to view installed packages, that are outdated
sort installed.txt unmaintained.txt | uniq -d > unmaintained_and_installed.txt
less unmaintained_and_installed.txt

