# shellcheck shell=bash
# no need for shebang - this file is loaded from charts.d.plugin
# SPDX-License-Identifier: GPL-3.0-or-later

# netdata
# real-time performance and health monitoring, done right!
# (C) 2016 Costa Tsaousis <costa@tsaousis.gr>
#

# if this chart is called X.chart.sh, then all functions and global variables
# must start with X_

# _update_every is a special variable - it holds the number of seconds
# between the calls of the _update() function
temp_update_every=

# the priority is used to sort the charts on the dashboard
# 1 = the first chart
temp_priority=1

# global variables to store our collected data
# remember: they need to start with the module name example_
temp_cpu=40
temp_cpu_file=/sys/class/thermal/thermal_zone0/temp

temp_get() {
  # do all the work to collect / calculate the values
  # for each dimension
  #
  # Remember:
  # 1. KEEP IT SIMPLE AND SHORT
  # 2. AVOID FORKS (avoid piping commands)
  # 3. AVOID CALLING TOO MANY EXTERNAL PROGRAMS
  # 4. USE LOCAL VARIABLES (global variables may overlap with other modules)

  if [ -f "$temp_cpu_file" ]; then
    temp_cpu=$(cat $temp_cpu_file)
  else
    return 1
  fi

  # this should return:
  #  - 0 to send the data to netdata
  #  - 1 to report a failure to collect the data

  return 0
}

# _check is called once, to find out if this chart should be enabled or not
temp_check() {
  # this should return:
  #  - 0 to enable the chart
  #  - 1 to disable the chart

  # check something
  
  # check that we can collect data
  temp_get || return 1

  return 0
}

# _create is called once, to create the charts
temp_create() {
  # create the chart with 3 dimensions
  cat << EOF
CHART Gauge.Temperature 'Temperature' "CPU Temperature" "Celsius Degree" "Temperature" "" line $temp_priority $temp_update_every
DIMENSION CPU '' absolute 1 1000
EOF

  return 0
}

# _update is called continuously, to collect the values
temp_update() {
  # the first argument to this function is the microseconds since last update
  # pass this parameter to the BEGIN statement (see bellow).

  temp_get || return 1

  # write the result of the work.
  cat << VALUESEOF
BEGIN Gauge.Temperature $1
SET CPU = $temp_cpu
END
VALUESEOF

  return 0
}