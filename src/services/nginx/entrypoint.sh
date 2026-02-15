#!/bin/sh

# Run all executable scripts in /entrypoint.d/ in sorted order
find "/entrypoint.d/" -follow -type f -print | sort -V | while read -r f; do
	[ -x "$f" ] || continue
  	"$f"
done

exec "$@"
