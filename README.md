# 42Inception


```
sudo echo "127.0.0.1	yaltayeh.42.fr" >> /etc/hosts
```

```
openssl req -x509 -newkey rsa:4096 -nodes -days 365 \
  -keyout certs/server.key \
  -out certs/server.crt \
  -subj "/CN=pi.42.fr"

```