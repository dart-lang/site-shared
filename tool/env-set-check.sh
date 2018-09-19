# This bash file is meant to be source'd, not executed.
#
# Use it to check if env-set.sh has been sourced.
# Note: because this is sourced, we avoid creating local variables/functions.

if [[ -n "$DART_SITE_ENV_DEFS" ]]; then
  return 0;
elif [[ -e ./tool/env-set.sh ]]; then
  echo "ERROR: source ./tool/env-set.sh before executing this script ($(basename $0))"
elif [[ -e ./tool/shared/env-set.sh ]]; then
  echo "ERROR: source ./tool/shared/env-set.sh before executing this script ($(basename $0))"
else
  echo "ERROR: source env-set.sh before executing this script ($(basename $0))"
fi

return 1;
