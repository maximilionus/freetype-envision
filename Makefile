NAME := freetype-envision
VERSION := 0.1.0

DIR_SRC=src
DIR_BUILD=build

DIR_PROFILED_DEST := /etc/profile.d
DIR_PROFILED_SRC := $(DIR_SRC)/profile.d

SRC_FTSCRIPT_NAME := freetype-envision-safe.sh


# Show package information
info:
	@echo "$(NAME), version: $(VERSION)"

# Prepare the release for distribution
# TODO: Needs tweaking
build: info
	mkdir -v -p $(DIR_BUILD)/$(NAME)-$(VERSION)
	cp -v -r $(DIR_SRC)/* $(DIR_BUILD)/$(NAME)-$(VERSION)
	tar --directory $(DIR_BUILD) -cvf $(DIR_BUILD)/$(NAME)-$(VERSION).tar.gz $(NAME)-$(VERSION)

# Install the project to the system
install: info
	@echo "Installing the profile.d script (safe preset)"
	install -m 644 $(DIR_PROFILED_SRC)/$(SRC_FTSCRIPT_NAME) $(DIR_PROFILED_DEST)
	@echo "Success. Reboot to apply the changes."

# Revert the "install" command
uninstall: info
	@echo "Uninstalling the profile.d script (safe preset)"
	rm $(DIR_PROFILED_DEST)/$(SRC_FTSCRIPT_NAME)
	@echo "Success. Reboot to apply the changes."
