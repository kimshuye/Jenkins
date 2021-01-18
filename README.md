# Jenkins

## Ubuntu version 20.04.1

```bash

lsb_release -a

```

output:

```
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 20.04.1 LTS
Release:        20.04
Codename:       focal
```

## Install JDK version latest

```bash

sudo apt install -y default-jre

```

## Download jenkins.war 


https://www.jenkins.io/download/

* 2.263.2 LTS

Jenkins.war


## Step 1 — Installing Jenkins

The version of Jenkins included with the default Ubuntu packages is often behind the latest available version from the project itself. To ensure you have the latest fixes and features, use the project-maintained packages to install Jenkins.


First, add the repository key to the system:

```bash

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -

```
 

After the key is added the system will return with OK.

Next, let’s append the Debian package repository address to the server’s sources.list:


```bash

sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

```
 

After both commands have been entered, we’ll run update so that apt will use the new repository.

```bash

sudo apt update

```
 

Finally, we’ll install Jenkins and its dependencies.

```bash

sudo apt install -y jenkins

```
 

Now that Jenkins and its dependencies are in place, we’ll start the Jenkins server.
## Step 2 — Starting Jenkins

Let’s start Jenkins by using systemctl:

```bash

sudo systemctl start jenkins

```
Since systemctl doesn’t display status output, we’ll use the status command to verify that Jenkins started successfully:

```bash

sudo systemctl status jenkins

```
 

If everything went well, the beginning of the status output shows that the service is active and configured to start at boot:

Output:

```bash
● jenkins.service - LSB: Start Jenkins at boot time
   Loaded: loaded (/etc/init.d/jenkins; generated)
   Active: active (exited) since Fri 2020-06-05 21:21:46 UTC; 45s ago
     Docs: man:systemd-sysv-generator(8)
    Tasks: 0 (limit: 1137)
   CGroup: /system.slice/jenkins.service
```

## Add jenkins user to docker group

```bash

sudo usermod -a -G docker jenkins

```

* เพื่อให้ใช้งาน Docker , docker-compose ได้ ควรติดตั้ง Docker , docker-compose แล้ว Restart เครื่อง 1 ครั้ง ทำให้ Jenkins CI สามารถใช้งาน


```bash

reboot

```

## Important To Miss


* กรณีที่ใช้งาน Private Jenkins และต้องการ ให้สามารถ ใช้คำสั่ง ดั่งเดิม ได้เลย เช่น


#### e2e
- robot (python3)
- cypress (nodejs)


#### integration
- robot (python3)
- npm (nodejs)
- newman (nodejs)


#### other
- make (apt)


#### docker hub login

```bash

cat ~/my_password.txt | docker login --username tokdev --password-stdin

```

