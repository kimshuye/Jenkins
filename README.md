# Jenkins


### Start Jenkins

```bash
docker run \
    --name myjenkins  \
    -p 8080:8080 \
    -p 5000:5000 \
    -d \
    -v ${PWD}/jenkins_home:/var/jenkins_home \
    jenkins/jenkins:2.263.1


```

