# Makefile - required by Koji that calls "make source" to create source tarball for RPM builds
# based on: https://github.com/avocado-framework/aexpect.git tag: 1.8.0
PROJECT=clockres
VERSION=$(shell awk '/^Version:/ { print $$2 }' $(PROJECT).spec)

all:
	@echo "make clean - Get rid of scratch and byte files"
	@echo "make source - Create source package"

source: clean
	if test ! -d SOURCES; then mkdir SOURCES; fi
	git archive --prefix="$(PROJECT)-$(VERSION)/" -o "SOURCES/$(PROJECT)-$(VERSION).tar.gz" HEAD

clean:
	rm -rf build/ MANIFEST BUILD BUILDROOT SPECS RPMS SRPMS SOURCES

.PHONY: source clean

