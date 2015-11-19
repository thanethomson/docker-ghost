#!/bin/bash
if [ $(ps aux | grep node | grep -v grep | wc -l | tr -s "\n") -eq 0 ]
then
  # copy all of the content data from the Ghost source to our content volume
  for dir in "$GHOST_DIR/content"/*/; do
    targetDir="$GHOST_CONTENT/$(basename "$dir")"
    mkdir -p "$targetDir"
    if [ -z "$(ls -A "$targetDir")" ]; then
      tar -c --one-file-system -C "$dir" . | tar xC "$targetDir"
    fi
  done
  # update our nginx config file
  sed \
    -e "s#GHOST_DIR#${GHOST_DIR}#" \
    -e "s#GHOST_CONTENT#${GHOST_CONTENT}#" \
    -e "s#GHOST_HOST#${GHOST_HOST}#" \
    </etc/nginx/nginx.ghost.conf >/etc/nginx/nginx.conf
  # restart nginx
  service nginx restart
  # Ghost config/execution
  export PATH=/usr/local/bin:$PATH
  chown -R ghost:ghost $GHOST_DIR
  chown -R ghost:ghost $GHOST_CONTENT
  # run in the foreground as the ghost user, otherwise Docker assumes
  # this container's startup was a failure
  NODE_ENV=production \
    gosu ghost \
    forever \
    --pidFile "${GHOST_DIR}/ghost.pid" \
    -a -o "${GHOST_LOGS}/output.log" -e "${GHOST_LOGS}/errors.log" \
    --sourceDir "$GHOST_DIR" index.js
fi
