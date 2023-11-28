NAME := freetype-mac-style
VERSION := 1.0.0

DIR_SRC=src
DIR_BUILD=build

DIR_PROFILED_DEST := /etc/profile.d
DIR_PROFILED_SRC := $(DIR_SRC)/profile.d

SRC_FTSCRIPT_NAME := freetype-mac-style.sh


# Prepare the release for distribution
build:
	mkdir -v -p $(DIR_BUILD)/$(NAME)-$(VERSION)
	cp -v -r $(DIR_SRC)/* $(DIR_BUILD)/$(NAME)-$(VERSION)
	tar -cvf $(DIR_BUILD)/$(NAME)-$(VERSION).tar.gz $(DIR_BUILD)/$(NAME)-$(VERSION)

# Install the project to the system
install:
	@echo "Installing the profile.d script"
	install -m 644 $(DIR_PROFILED_SRC)/$(SRC_FTSCRIPT_NAME) $(DIR_PROFILED_DEST)
	@echo "Success. Reboot to apply the changes."

# Revert the "install" command
uninstall:
	@echo "Uninstalling the profile.d script"
	rm $(DIR_PROFILED_DEST)/$(SRC_FTSCRIPT_NAME)
	@echo "Success. Reboot to apply the changes."
