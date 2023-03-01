# Docker base image for pyTheiaSfM
How to push a new version:
```bash
NEW_VERSION=1.1.0
docker build -t pytheia_base:${NEW_VERSION} .
docker login --username=username
docker images
docker tag IMAGE_ID username/pytheia_base:1.1.0
docker push username/pytheia_base:1.1.0
``` 