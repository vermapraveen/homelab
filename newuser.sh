sudo -i
useradd -m -s /bin/bash divya
passwd divya

echo  -e 'divya\tALL=(ALL)\tNOPASSWD:\tALL' > /etc/sudoers.d/divya

mkpasswd --method=SHA-512

$6$gdsHM2g3/q$YHxkqkQcqLlJfevGplOo7sEGaW06dTHqFbxLEu/GIsbkDv0JY0rdgfyADwM4mUFG1ICSjSahsY69haJ0iVg1G0

su - home
ssh-keygen -t rsa

ssh-keyscan blue.pkvnw >> ~/.ssh/known_hosts
ssh-keyscan charlie.pkvnw >> ~/.ssh/known_hosts
ssh-keyscan delta.pkvnw >> ~/.ssh/known_hosts
ssh-keyscan sierra.pkvnw >> ~/.ssh/known_hosts