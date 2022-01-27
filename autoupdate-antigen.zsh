# Copyright 2014 Joe Block <jpb@unixorn.net>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

if [ -z "$ANTIBODY_PLUGIN_UPDATE_DAYS" ]; then
  ANTIBODY_PLUGIN_UPDATE_DAYS=7
fi

if [ -z "$ANTIBODY_SYSTEM_UPDATE_DAYS" ]; then
  ANTIBODY_SYSTEM_UPDATE_DAYS=7
fi

if [ -z "$ANTIBODY_PLUGIN_LIST_F" ]; then
  if [ -f '~/.zsh_plugins.txt' ]; then
    ANTIBODY_PLUGIN_LIST_F='~/.zsh_plugins.txt'
  fi
fi

if [ -z "$ANTIBODY_PLUGIN_SOURCE_F" ]; then
  if [ -f '~/.zsh_plugins.sh' ]; then
    ANTIBODY_PLUGIN_SOURCE_F='~/.zsh_plugins.sh'
  fi
fi

if [ -z "$ANTIBODY_SYSTEM_RECEIPT_F" ]; then
  ANTIBODY_SYSTEM_RECEIPT_F='.antibody_system_lastupdate'
fi

if [ -z "$ANTIBODY_PLUGIN_RECEIPT_F" ]; then
  ANTIBODY_PLUGIN_RECEIPT_F='.antibody_plugin_lastupdate'
fi

function check_interval() {
  now=$(date +%s)
  if [ -f ~/${1} ]; then
    last_update=$(cat ~/${1})
  else
    last_update=0
  fi
  interval=$(expr ${now} - ${last_update})
  echo ${interval}
}

day_seconds=$(expr 24 \* 60 \* 60)
system_seconds=$(expr ${day_seconds} \* ${ANTIBODY_SYSTEM_UPDATE_DAYS})
plugins_seconds=$(expr ${day_seconds} \* ${ANTIBODY_PLUGIN_UPDATE_DAYS})

last_plugin=$(check_interval ${ANTIBODY_PLUGIN_RECEIPT_F})
last_system=$(check_interval ${ANTIBODY_SYSTEM_RECEIPT_F})

if [ ! -z "$ANTIBODY_PLUGIN_LIST_F" ]; then
  last_change=$(date -f "$ANTIBODY_PLUGIN_LIST_F" +%s)
fi

if [ ! -z "$ANTIBODY_PLUGIN_SOURCE_F" ]; then
  last_bundle=$(date -f "$ANTIBODY_PLUGIN_SOURCE_F" +%s)
fi

if [ ${last_plugin} -gt ${plugins_seconds} ]; then
  if [ ! -z "$ANTIBODY_AUTOUPDATE_VERBOSE" ]; then
    echo "It has been $(expr ${last_plugin} / $day_seconds) days since your antibody plugins were updated"
    echo "Updating plugins"
  fi
  antibody update
  $(date +%s > ~/${ANTIBODY_PLUGIN_RECEIPT_F})
fi

if [ ${last_system} -gt ${system_seconds} ]; then
  if [ ! -z "$ANTIBODY_AUTOUPDATE_VERBOSE" ]; then
    echo "It has been $(expr ${last_plugin} / $day_seconds) days since your antibody was updated"
    echo "Updating antibody..."
  fi
  antibody selfupdate
  $(date +%s > ~/${ANTIBODY_SYSTEM_RECEIPT_F})
fi

if [ ! -z "$last_change" ]; then
  if [ -z "$last_bundle" ] || [ ${last_change} -gt ${last_bundle} ]; then
    if [ ! -z "$ANTIBODY_AUTOUPDATE_VERBOSE" ]; then
      echo "Changes were made to your plugin list, but have not been bundled yet"
      echo "Updating antibody plugins..."
    fi
    antibody bundle < "$ANTIBODY_PLUGIN_LIST_F" > "$ANTIBODY_PLUGIN_SOURCE_F"
  fi
fi

# clean up after ourselves
unset ANTIBODY_PLUGIN_RECEIPT_F
unset ANTIBODY_PLUGIN_UPDATE_DAYS
unset ANTIBODY_SYSTEM_RECEIPT_F
unset ANTIBODY_SYSTEM_UPDATE_DAYS
unset ANTIBODY_PLUGIN_LIST_F
unset ANTIBODY_PLUGIN_SOURCE_F
unset day_seconds
unset last_plugin
unset last_system
unset plugins_seconds
unset system_seconds

unset -f check_interval
