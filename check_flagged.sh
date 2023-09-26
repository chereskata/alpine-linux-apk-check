#! /bin/ash

rm -rf /tmp/flagged
mkdir /tmp/flagged
cd /tmp/flagged

# download flagged package list
i=1; while [ "$i" -le 20 ]
do
    wget https://pkgs.alpinelinux.org/flagged?page=${i}
    i=$(( i + 1 ))
done

cat *page* | grep -e "<td class=\"package\">" | sed -e "s/ *<.*\">//" -e "s/<.*> *//" | sort -u > outdated.txt

# gather installed packages
apk list -I | sed -e "s/.*{//" -e "s/}.*//" | sort -u > installed.txt

# build intersection to view installed packages, that are outdated
sort installed.txt outdated.txt | uniq -d > outdated_and_installed.txt
less outdated_and_installed.txt
