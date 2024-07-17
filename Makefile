NAME=freetype-envision
PACKAGE_NAME=$(NAME)-$(VERSION)
VERSION=0.7.0
ARCHIVE_FMT=.tar.gz
BUILD_DIR=build
DIST_DIR=dist


.PHONY: build clean

build:
	mkdir -p $(BUILD_DIR)/$(PACKAGE_NAME) $(DIST_DIR)
	cp -r src/* $(BUILD_DIR)/$(PACKAGE_NAME)
	cd $(BUILD_DIR); \
		tar -czvf $(PACKAGE_NAME)$(ARCHIVE_FMT) $(PACKAGE_NAME)
	mv $(BUILD_DIR)/$(PACKAGE_NAME)$(ARCHIVE_FMT) $(DIST_DIR)

clean:
	rm -rf $(BUILD_DIR) \
		$(DIST_DIR)
