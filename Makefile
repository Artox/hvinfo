# Copyright (C) 2015 Daniil Baturin <daniil@baturin.org>
#
# This file is part of hvinfo.
#
# hvinfo is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# hvinfo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with hvinfo.  If not, see <http://www.gnu.org/licenses/>.

PREFIX = /usr
BINDIR = bin

BUILD_DIR = build

CONFIG = config.def

DESTDIR = ""

GPRBUILD = gprbuild
GPRCLEAN = gprclean
GPRINSTALL = gprinstall
GNATPREP = gnatprep

INSTALL = install

BUILD_TARGET =
BUILD_FLAGS =

ifdef BUILD_TARGET
BUILD_FLAGS = --target=$(BUILD_TARGET)
endif

all: config.def src/config.ads hvinfo

config.def:
	./mkdefs.sh

src/config.ads: VERSION mkconfig.sh src/config.ads.in
	GNATPREP=$(GNATPREP) ./mkconfig.sh

.PHONY: hvinfo
hvinfo:
	mkdir -p $(BUILD_DIR)
	$(GPRBUILD) -R -Phvinfo $(BUILD_FLAGS)

clean:
	if test -d $(BUILD_DIR); then \
	  $(GPRCLEAN); \
	  rm -rf $(BUILD_DIR);\
	fi
	rm -f $(CONFIG)
	rm -f src/config.ads

install:
	$(INSTALL) -d $(DESTDIR)/$(PREFIX)/$(BINDIR)
	$(INSTALL) $(BUILD_DIR)/hvinfo $(DESTDIR)/$(PREFIX)/$(BINDIR)
