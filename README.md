*This project has been created as part of the 42 curriculum by*

# 42 Inception

## Description

## Instructions

## Resources

```
sudo echo "127.0.0.1	yaltayeh.42.fr" >> /etc/hosts
```

```
openssl req -x509 -newkey rsa:4096 -nodes -days 365 \
  -keyout ssl/yaltayeh.42.fr.key \
  -out ssl/yaltayeh.42.fr.crt \
  -subj "/CN=yaltayeh.42.fr"
```