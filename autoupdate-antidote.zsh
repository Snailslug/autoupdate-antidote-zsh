# Copyright 2024 John Wood <john@snailslug.com>
# Copyright 2022 Jacob Birkett <jacob@birkett.dev>
# Copyright 2014 Joe Block <jpb@unixorn.net>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

if [ -z "$ANTIDOTE_AUTOUPDATE_VERBOSE" ]; then
  ANTIDOTE_AUTOUPDATE_VERBOSE=true
fi

if [ -z "$ANTIDOTE_PLUGIN_UPDATE_DAYS" ]; then
  ANTIDOTE_PLUGIN_UPDATE_DAYS=7
fi

if [ -z "$ANTIDOTE_PLUGIN_LIST_F" ] && [ -f "$HOME/.zsh_plugins.txt" ]; then
    ANTIDOTE_PLUGIN_LIST_F="$HOME/.zsh_plugins.txt"
fi

if [ -z "$ANTIDOTE_PLUGIN_SOURCE_F" ] && [ -f "$HOME/.zsh_plugins.sh" ]; then
    ANTIDOTE_PLUGIN_SOURCE_F="$HOME/.zsh_plugins.sh"
fi

if [ -z "$ANTIDOTE_PLUGIN_RECEIPT_F" ]; then
  ANTIDOTE_PLUGIN_RECEIPT_F="$HOME/.antidote_plugin_lastupdate"
fi

function check_interval() {
  now=$(date +%s)
  if [ -f ${1} ]; then
    last_update=$(cat ${1})
  else
    last_update=0
  fi
  interval=$(expr ${now} - ${last_update})
  echo ${interval}
}

day_seconds=$(expr 24 \* 60 \* 60)
plugins_seconds=$(expr ${day_seconds} \* ${ANTIDOTE_PLUGIN_UPDATE_DAYS})

last_plugin=$(check_interval "${ANTIDOTE_PLUGIN_RECEIPT_F}")

if [ ! -z "$ANTIDOTE_PLUGIN_LIST_F" ]; then
  last_change=$(date -r "$ANTIDOTE_PLUGIN_LIST_F" +%s)
fi

if [ ! -z "$ANTIDOTE_PLUGIN_SOURCE_F" ]; then
  last_bundle=$(date -r "$ANTIDOTE_PLUGIN_SOURCE_F" +%s)
fi

if [ ${last_plugin} -gt ${plugins_seconds} ]; then
  if [ "$ANTIDOTE_AUTOUPDATE_VERBOSE" = true ]; then
    echo "It has been $(expr ${last_plugin} / $day_seconds) days since your antidote plugins were updated."
    echo "Updating antidote plugins..."
  fi
  antidote update
  $(date +%s > "${ANTIDOTE_PLUGIN_RECEIPT_F}")
fi

if [ ! -z "$last_change" ]; then
  if [ -z "$last_bundle" ] || [ ${last_change} -gt ${last_bundle} ]; then
    if [ "$ANTIDOTE_AUTOUPDATE_VERBOSE" = true ]; then
      echo "Changes were made to your plugin list, but have not been bundled yet."
      echo "Updating antidote plugins..."
    fi
    antidote update
    antidote bundle < "$ANTIDOTE_PLUGIN_LIST_F" > "$ANTIDOTE_PLUGIN_SOURCE_F"
    $(date +%s > "${ANTIDOTE_PLUGIN_RECEIPT_F}")
  fi
fi

# clean up after ourselves
unset ANTIDOTE_AUTOUPDATE_VERBOSE
unset ANTIDOTE_PLUGIN_RECEIPT_F
unset ANTIDOTE_PLUGIN_UPDATE_DAYS
unset ANTIDOTE_PLUGIN_LIST_F
unset ANTIDOTE_PLUGIN_SOURCE_F
unset day_seconds
unset plugins_seconds
unset last_plugin

unset -f check_interval
