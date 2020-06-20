BUILD_DIR = build
BINARY = $(BUILD_DIR)/mirror

build: main.go mirror
	go get -v
	go test
	go build -o $(BINARY)
