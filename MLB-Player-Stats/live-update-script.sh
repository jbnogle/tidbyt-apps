#!/bin/bash

x=1
while [ $x -le 48 ]
do
    echo Updating Royals Stats
    pixlet render mlb-fantasy.star team=Royals   
    pixlet push --installation-id BBStatsRoyals impossibly-absolved-advantaged-scorpion-55c mlb-fantasy.webp

    echo Updating Cardinals Stats
    pixlet render mlb-fantasy.star team=Cardinals   
    pixlet push --installation-id BBStatsCardinals impossibly-absolved-advantaged-scorpion-55c mlb-fantasy.webp

    echo Updating Braves Stats
    pixlet render mlb-fantasy.star team=Braves   
    pixlet push --installation-id BBStatsBraves impossibly-absolved-advantaged-scorpion-55c mlb-fantasy.webp

    echo Updating Blue Jays Stats
    pixlet render mlb-fantasy.star team=Blue\ Jays   
    pixlet push --installation-id BBStatsJays impossibly-absolved-advantaged-scorpion-55c mlb-fantasy.webp

    # echo Updating Rangers Stats
    # pixlet render mlb-fantasy.star team=Rangers   
    # pixlet push --installation-id BBStatsRangers impossibly-absolved-advantaged-scorpion-55c mlb-fantasy.webp

    echo Updating Angels Stats
    pixlet render mlb-fantasy.star team=Angels   
    pixlet push --installation-id BBStatsAngels impossibly-absolved-advantaged-scorpion-55c mlb-fantasy.webp
    
    echo Updating Phillies Stats
    pixlet render mlb-fantasy.star team=Phillies   
    pixlet push --installation-id BBStatsPhils impossibly-absolved-advantaged-scorpion-55c mlb-fantasy.webp
    
    echo Updating Red Sox Stats
    pixlet render mlb-fantasy.star team=Red\ Sox    
    pixlet push --installation-id BBStatsRedSox impossibly-absolved-advantaged-scorpion-55c mlb-fantasy.webp

    # echo Updating Twins Stats
    # pixlet render mlb-fantasy.star team=Twins  
    # pixlet push --installation-id BBStatsTwins impossibly-absolved-advantaged-scorpion-55c mlb-fantasy.webp

    # echo Updating Mariners Stats
    # pixlet render mlb-fantasy.star team=Mariners   
    # pixlet push --installation-id BBStatsMariners impossibly-absolved-advantaged-scorpion-55c mlb-fantasy.webp

    # echo Updating Diamondbacks Stats
    # pixlet render mlb-fantasy.star team=Diamondbacks 
    # pixlet push --installation-id BBStatsDbacks impossibly-absolved-advantaged-scorpion-55c mlb-fantasy.webp
    
    echo Updating Giants Stats
    pixlet render mlb-fantasy.star team=Giants 
    pixlet push --installation-id BBStatsGiants impossibly-absolved-advantaged-scorpion-55c mlb-fantasy.webp
    
    echo Updating Cubs Stats
    pixlet render mlb-fantasy.star team=Cubs 
    pixlet push --installation-id BBStatsCubs impossibly-absolved-advantaged-scorpion-55c mlb-fantasy.webp

    echo Updating Dodgers Stats
    pixlet render mlb-fantasy.star team=Dodgers  
    pixlet push --installation-id BBStatsDodgers impossibly-absolved-advantaged-scorpion-55c mlb-fantasy.webp
    
    echo Updating Guardians Stats
    pixlet render mlb-fantasy.star team=Guardians  
    pixlet push --installation-id BBStatsGuardians impossibly-absolved-advantaged-scorpion-55c mlb-fantasy.webp

    echo Updating Athletics Stats
    pixlet render mlb-fantasy.star team=Athletics  
    pixlet push --installation-id BBStatsAthletics impossibly-absolved-advantaged-scorpion-55c mlb-fantasy.webp
    
    # echo Updating Astros Stats
    # pixlet render mlb-fantasy.star team=Astros  
    # pixlet push --installation-id BBStatsAstros impossibly-absolved-advantaged-scorpion-55c mlb-fantasy.webp
    
    echo Updating Rays Stats
    pixlet render mlb-fantasy.star team=Rays   
    pixlet push --installation-id BBStatsRays impossibly-absolved-advantaged-scorpion-55c mlb-fantasy.webp
    
    # echo Updating Nats Stats
    # pixlet render mlb-fantasy.star team=Nationals   
    # pixlet push --installation-id BBStatsNats impossibly-absolved-advantaged-scorpion-55c mlb-fantasy.webp
    
    # echo Updating Rockies Stats
    # pixlet render mlb-fantasy.star team=Rockies   
    # pixlet push --installation-id BBStatsRox impossibly-absolved-advantaged-scorpion-55c mlb-fantasy.webp
    
    echo Updating Brewers Stats
    pixlet render mlb-fantasy.star team=Brewers   
    pixlet push --installation-id BBStatsBrewers impossibly-absolved-advantaged-scorpion-55c mlb-fantasy.webp
    
    echo Updating Tigers Stats
    pixlet render mlb-fantasy.star team=Tigers   
    pixlet push --installation-id BBStatsTigers impossibly-absolved-advantaged-scorpion-55c mlb-fantasy.webp
    
    # echo Updating Pirates Stats
    # pixlet render mlb-fantasy.star team=Pirates   
    # pixlet push --installation-id BBStatsPirates impossibly-absolved-advantaged-scorpion-55c mlb-fantasy.webp

    # echo Updating Marlins Stats
    # pixlet render mlb-fantasy.star team=Marlins 
    # pixlet push --installation-id BBStatsMarlins impossibly-absolved-advantaged-scorpion-55c mlb-fantasy.webp
  
  x=$(( $x + 1 ))
  sleep 600
done