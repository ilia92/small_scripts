#/bin/bash

src=$1
dest=$2

printf "Destination IP: "
dig +short $dest

if [ "$3" = "--calibrate" ]; then

curl --silent http://$src/cm?cmnd=Status%208 > src_status8.txt

voltage=`cat src_status8.txt | jq .StatusSNS.ENERGY.Voltage`
current=`echo "$(cat src_status8.txt | jq .StatusSNS.ENERGY.Current)*1000" | bc -l | sed "s|.000||g"`
power=`cat src_status8.txt | jq .StatusSNS.ENERGY.Power`

printf "Voltage:\t$voltage\nCurrent:\t$current\nPower:\t\t$power\n"

printf "Use hardware counter: "
curl --silent http://$dest/cm?cmnd=SetOption72%201 |jq

curl --silent http://$dest/cm?cmnd=module%2043 |jq

printf "\n\n"
curl --silent http://$dest/cm?cmnd=VoltageSet%20$voltage | jq .
curl --silent http://$dest/cm?cmnd=CurrentSet%20$current | jq .
curl --silent http://$dest/cm?cmnd=PowerSet%20$power | jq .
sleep 5
fi

curl --silent http://$src/cm?cmnd=Status%208 > new_src_status8.txt
curl --silent http://$dest/cm?cmnd=Status%208 > new_dest_status8.txt
sleep 1

new_src_voltage=`cat new_src_status8.txt | jq .StatusSNS.ENERGY.Voltage`
new_src_curr=`echo "$(cat new_src_status8.txt | jq .StatusSNS.ENERGY.Current)*1000" | bc -l | sed "s|.000||g"`
new_src_pf=`cat new_src_status8.txt | jq .StatusSNS.ENERGY.Power`

new_dest_voltage=`cat new_dest_status8.txt | jq .StatusSNS.ENERGY.Voltage`
new_dest_curr=`echo "$(cat new_dest_status8.txt | jq .StatusSNS.ENERGY.Current)*1000" | bc -l | sed "s|.000||g"`
new_dest_pf=`cat new_dest_status8.txt | jq .StatusSNS.ENERGY.Power`

printf "Status:\n"
printf "Voltage:\t$new_src_voltage\t$new_dest_voltage\n"
printf "Current:\t$new_src_curr\t$new_dest_curr\n"
printf "Power:\t\t$new_src_pf\t$new_dest_pf\n"

