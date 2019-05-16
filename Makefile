IMAGE_NAME=atlas

build:
	docker build -t $(IMAGE_NAME) .

run:
	docker run -p 21000:21000 $(IMAGE_NAME)

sh:
	docker run -it --rm $(IMAGE_NAME) /bin/bash

stop:
	docker stop $(IMAGE_NAME)