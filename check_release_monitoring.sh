#! /bin/ash

rm -rf /tmp/unmonitored
mkdir /tmp/unmonitored
cd /tmp/unmonitored

# gather installed packages
apk list -I | sed -e "s/.*{//" -e "s/}.*//" | sort -u > installed.txt

while read package
do
    http_status=$(curl -s -o /dev/null -w '%{http_code}' https://release-monitoring.org/api/project/Alpine/$package)

    case $http_status in
	200)
	    echo -e "\033[38;2;0;255;0m\
		    $package is monitored\
		    \033[m"
	;;
	*)
	    echo -e "\033[38;2;255;0;0m\
		    $package is unmonitored\
		    \033[m"
   
	    echo "$package" >> unmonitored.txt
	;;
    esac
done < installed.txt

# build intersection to view installed packages, that are outdated
less unmonitored.txt
