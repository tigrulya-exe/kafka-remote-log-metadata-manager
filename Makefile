##
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##
VERSION := $(shell grep -o -E '^version=[0-9]+\.[0-9]+\.[0-9]+(-SNAPSHOT)?' gradle.properties | cut -c9-)
IMAGE_NAME := arenadata/kafka-with-ts-plugin
IMAGE_VERSION := latest
IMAGE_TAG := $(IMAGE_NAME):$(IMAGE_VERSION)

.PHONY: all clean checkstyle build test integration_test docker_image docker_push

all: clean build test

clean:
	./gradlew clean

checkstyle:
	./gradlew checkstyleMain checkstyleTest checkstyleIntegrationTest

build:
	./gradlew build distTar -x test -x integrationTest

test: build
	./gradlew test

integration_test: build
	./gradlew integrationTest

.PHONY: docker_image
docker_image: build
	docker build . \
		-f docker/Dockerfile \
		--build-arg _VERSION=$(VERSION) \
		-t $(IMAGE_TAG)

.PHONY: docker_push
docker_push:
	docker push $(IMAGE_TAG)
