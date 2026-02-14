#!/bin/sh

find "/entrypoint.d/" -follow -type f -print | sort -V | while read -r f; do
	[ -x "$f" ] || continue
  	"$f"
done

exec "$@"
