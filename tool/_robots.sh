# This bash file is meant to be source'd, not executed.
#
# Utility to help toggle the generated site's robots.txt

source ./tool/shared/env-set-check.sh

ROBOTS_FILE="$SITE_JEKYLL_DEST/robots.txt"
NO_ROBOTS_FILE="$SITE_JEKYLL_SRC/_no-robots.txt"
OK_ROBOTS_FILE="$SITE_JEKYLL_SRC/_robots.txt"
ROBOTS_FILE_SAVED="$TMP/_robots.txt.saved"

function _error() { echo "ERROR: $1"; exit 1; }

function robotsOptionsUsage() {
  ACTION="${1:-deploying}"
  echo "  --robots <RS>  Where <RS> is either 'ok' or 'no'. In either case, if $ROBOTS_FILE exists"
  echo "                 it is removed or replaced before $ACTION, and restored afterwards."
  echo
  echo "                 'ok': If $OK_ROBOTS_FILE exists it is copied to $ROBOTS_FILE;"
  echo "                       otherwise, an empty config file is used."
  echo "                 'no': If $NO_ROBOTS_FILE exists it is copied to $ROBOTS_FILE;"
  echo "                       otherwise, a standard config disallowing all agents is used."
  echo "                 'site': Use the site generated robots file. You get the same effect"
  echo "                       when you omit the --robots flag entirely."
  echo
}

function saveAndSetRobotsTxt() {
  ROBOTS="$1"
  if [[ $ROBOTS == "no" ]]; then
    _saveRobotsTxt
    _setNoRobots
  elif [[ $ROBOTS == "ok" ]]; then
    _saveRobotsTxt
    _setRobotsOk
  elif [[ -n $ROBOTS && $ROBOTS != "site" ]]; then
    _error "Unrecognized value for --robots option: $ROBOTS"
  # else
  #   Use site-generated robots.txt file.
  fi
}

function _saveRobotsTxt() {
  if [[ -e "$ROBOTS_FILE" ]]; then
    ([[ -z $QUIET ]] && set -x; mv $ROBOTS_FILE $ROBOTS_FILE_SAVED);
  # elif [[ -z $QUIET ]]; then
  #   echo "INFO: there is no $ROBOTS_FILE_SAVED file. Nothing to save."
  fi
}

function _setNoRobots() {
  if [[ -e "$NO_ROBOTS_FILE" ]]; then
    ([[ -z $QUIET ]] && set -x; cp $NO_ROBOTS_FILE $ROBOTS_FILE)
  else
    echo "User-agent: *" > $ROBOTS_FILE
    echo "Disallow: /" >> $ROBOTS_FILE
  fi
}

function _setRobotsOk() {
  if [[ -e "$OK_ROBOTS_FILE" ]]; then
    ([[ -z $QUIET ]] && set -x; cp $OK_ROBOTS_FILE $ROBOTS_FILE)
  else
    echo "# All robots welcome!" > $ROBOTS_FILE
  fi
}

function restoreRobotsTxt() {
  if [[ -e "$ROBOTS_FILE_SAVED" ]]; then
    ([[ -z $QUIET ]] && set -x; mv $ROBOTS_FILE_SAVED $ROBOTS_FILE);
  elif [[ -z $QUIET ]]; then
    echo "INFO: there is no $ROBOTS_FILE_SAVED file. Nothing to restore."
  fi
}

function printRobotsTxt() {
  if [[ -n $QUIET ]]; then return 0; fi
  echo
  if [[ -e "$ROBOTS_FILE" ]]; then
    echo "$ROBOTS_FILE file contents:"
    echo "-----------------------------------------------------------"
    cat "$ROBOTS_FILE"
    echo "-----------------------------------------------------------"
  else
    echo "INFO: the site has no $ROBOTS_FILE, so all robots are welcome."
  fi
  echo
}
