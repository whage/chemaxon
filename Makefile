BUILD_DIR = build
BINARY = $(BUILD_DIR)/mirror

default: build

build: main.go mirror
	go get -v
	go test
	go build -o $(BINARY)

serve: $(BINARY)
	$(BINARY)

# TODO: get ECR repo URL
docker-build:
	docker build -t ecr-chemaxon .
