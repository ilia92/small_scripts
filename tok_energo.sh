#!/bin/bash

printf "\ntok.sh [old_day] [old_night] [new_day] [new_night]\n\n" 

day_tarif=0.14184
night_tarif=0.05442

other_plus=0.05398

day_kwh=$(($3-$1))
night_kwh=$(($4-$2))

printf "Day kWh:\t$day_kwh\nNight kWh:\t$night_kwh\n "


day_pr=`echo "$day_kwh * ($day_tarif + $other_plus) * 1.2" | bc -l`
night_pr=`echo "$night_kwh * ($night_tarif + $other_plus) * 1.2" | bc -l`
end_pr=`echo "$day_pr + $night_pr" | bc -l`

printf "\n"

printf "Day price:\t$day_pr\n"
printf "Night price:\t$night_pr\n"
printf "\n==========\n"
printf "\nEnd price: $end_pr BGN\n\n"

