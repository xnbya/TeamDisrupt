#!/bin/bash
apt-get update
apt-get upgrade -y
apt-get install postgresql git -y

#setup ssh config
key="-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAzDgRoU3gSfnGKL0z+gaPAp54zL+xdvgKjA9n58zL0BsGEFjq
juFeq9w8l8lcrRbwXG54XienuhkVqx5/XD2b3Z+N8Lm8gbIg6oqBb+bjP4o3CcBl
J9dCDuHvrIzEU5kMEtGXhhbvhI/P/o4ueu7QlzwA9/H7qDVEGQbkL9zOfJd66Qfd
T7WgkAl6xgq264AOGSGKClmMPYT87oeMPW7Qgw85Am+Kv5+heAIIuADMeufSmYKK
4tlbuq5jPQ5Vu3BIyQ3Frk+nRmFnoYNDeK8QEIfPyWSGh0b3ltxQD3Td4i4zbf9P
y7LfoBfoSKJ8jIKGuEej1jK7slDs5xECyAj55QIDAQABAoIBAFHjPbaHiqM/I6Vc
UMY18QxkzR2U1C1XQqts1gZNyYAWBfVyIgPO/O4+7pESrjW91/3IUj22+vuVaWnn
Xbx3+9L/UqQvZhY/fhFuHn7nf0IQQweG/UjfeN6M3FU9UNAQs5WsM20SL1Lhc86n
5p1mu3+ZEO5bOsT1Luw2JjPG/4lXYKhnjbXIUURqVZH+DvSolfUiYXs79LGWwU8N
abXeRqymUakk1I6jbN4Pcqx2gG2wZQU7tmI/iklcbXAEVwObhoE62Ux84e8AESrh
QBI3TVJz2+at6jw7U2CUWG0eD1vMKI2+dsUxWghkNyj52lzRHNK1a8Q+934rUgHw
WRG/HeECgYEA9KrxSiq+58Se2Fei9Rk+iBsoll2fYkjvf8JetRiKsOBjXjyFTIv4
DtmMXoV54opl2DNoeYgXdackSHyPSBJQDzY90b58f7dr2Z2zC2a9cfpN7v4syWWx
HnybJjdA92YLsaJKtOWwBOCcX1N3atsjbBI4Tvtaj/T28KiPK3XmXNkCgYEA1a2F
P4nd/0SgKjJwg+0Cyobvs3ixZaqNkeyMqkMAqUaGgI+rPLJuo0W9WKQzQ3uKtZ3s
hQve2vjKsYJHXDey7r2iDhH/JMEFeI38AhFYj8xah0/Siy86Vs8wNoYMA3U2lMD9
Uj01CoX8L+rcieNe37Gy4P3FTcuHAmX6DXa+De0CgYEAutP9xGC3vktJ8HGbIgXQ
1iXG7Gs5VdfT6n8FysuevEncFw2nzDflh5Ffup254N9Fvb4jvQnKwDCNaDyVPLef
Ir6MnikS8IOje10MZ1xgtTQpZqH4mSFqCpmj756poUDvFQmUemYZ7t+FCNW3joUf
m1qeXNFa6ipoloRgLxOsgKECgYEAgT/Wq9pfGDuQjjW4bXR+DbeVYoAM/iwuOihV
5d9llP79+OHueGaOGeDjaazY/WbLPpRqLwhBIz7+jGT7eUKPz22RiuVD6h1/i66G
01Feuoyn7dVQy7Qjm8LzrOdkeOr7uvsJwCcZ4GWvZ+SuxhFsn+7C/ulB4Y7M+Zxp
pp8+0vkCgYAtHup1V0XtxmXhjPfn04+muYG8C1sKOv2+yOEatX5Z10vxUxr+tjUv
JlMvoc6ABCv9Q9dFqC8dRuqlQ9r0/twVrYXlBZdh0kq7AAKlZycMzmXBbKTOEtQZ
aTCN5jc4SYK7G4oKnE9vrWaxiifJa9WzX/dXX+ulQDB3i73pgctXig==
-----END RSA PRIVATE KEY-----"

sshconfig="host github.com
  HostName github.com
  IdentityFile ~/.ssh/id_rsa_github
  User git"

hosts="|1|ZQVBF0swqh3i5zBSg4Kwgbt4/XI=|hQIGxNO4T6olF7jfTQ0a1LHolbI= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
|1|r+W4IcysXkngiJN9OSMXiHpL+O0=|mU6uA/vUxIGrxJn1iGFsvFSIPdg= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ=="

ahome=/home/ubuntu


echo "$key"  | sudo -u ubuntu tee  $ahome/.ssh/id_rsa_github
sudo -u ubuntu chmod 600 $ahome/.ssh/id_rsa_github
echo "$sshconfig" | sudo -u ubuntu tee $ahome/.ssh/config
echo "$hosts" | sudo -u ubuntu tee $ahome/.ssh/known_hosts

cd $ahome
sudo -u ubuntu git clone git@github.com:xnbya/TeamDisrupt.git
cd TeamDisrupt

#for testing branch
sudo -u ubuntu git checkout scripting

#setup postgres
cp -R database/root/* /

#TEST PW - DANGER!!!!
sudo -u postgres psql -c "CREATE USER pgadmin WITH PASSWORD 'SuperSecure11!';"
sudo -u postgres createdb pgadmin
service postgresql restart




