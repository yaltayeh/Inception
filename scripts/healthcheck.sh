while true; do
  if curl -s --head http://localhost:80 | grep "200 OK" > /dev/null; then
	echo "Nginx is up and running!"
	break
  else
	echo "Waiting for Nginx to be ready..."
	sleep 5
  fi
done