#!/bin/bash - 
#===============================================================================
#
#          FILE: reload.sh
# 
#         USAGE: ./reload.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: ROSHAN NAGEKAR 
#  ORGANIZATION: 
#       CREATED: Wednesday 24 April 2019 18:31
#      REVISION:  ---
#===============================================================================

#!/bin/bash

### Set initial time of file
LTIME=`stat -c %Z /etc/prometheus/prometheus.yml`

while true    
do
   ATIME=`stat -c %Z /etc/prometheus/prometheus.yml`

   if [[ "$ATIME" != "$LTIME" ]]
   then    
       `curl -X POST http://localhost:9090/-/reload`
       LTIME=$ATIME
   fi
   sleep 5
done

