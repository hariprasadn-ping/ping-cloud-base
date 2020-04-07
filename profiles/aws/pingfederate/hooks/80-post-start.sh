#!/usr/bin/env sh

${VERBOSE} && set -x

. "${HOOKS_DIR}/pingcommon.lib.sh"
. "${HOOKS_DIR}/utils.lib.sh"

echo "post-start: starting admin post-start initialization"

# Remove the marker file before running post-start initialization.
POST_START_INIT_MARKER_FILE="${OUT_DIR}/instance/post-start-init-complete"
rm -f "${POST_START_INIT_MARKER_FILE}"

# Wait until the server is up and running.
echo "post-start: waiting for admin server to be ready"
wait_for_server_ready

# Upload a backup right away after starting the server.
echo "post-start: uploading data backup to s3"
run_hook "82-upload-archive-data-s3.sh"

if test $? -eq 0; then
  touch "${POST_START_INIT_MARKER_FILE}"
  exit 0
fi

echo "post-start: admin post-start initialization failed"
exit 80