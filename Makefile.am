AUTOMAKE_OPTIONS = foreign
bin_PROGRAMS = myprogram
myprogram_SOURCES = main.cpp funcA.cpp funcA.h

PACKAGE = myprogram
VERSION = 1.0
PACKAGE_BUGREPORT = puzenko.artem@lll.kpi.ua

CTRLF_DIR = $(CURDIR)/deb/DEBIAN
CTRLF_NAME = $(CTRLF_DIR)/control

.PHONY: deb debug

deb:
	mkdir -p $(CTRLF_DIR)
	echo Package: $(PACKAGE) > $(CTRLF_NAME)
	echo Version: $(VERSION) >> $(CTRLF_NAME)
	echo Architecture: all >> $(CTRLF_NAME)
	echo Maintainer: $(PACKAGE_BUGREPORT) >> $(CTRLF_NAME)
	echo -n "Description:" >> $(CTRLF_NAME)
	cat aztec.1 >> $(CTRLF_NAME)
	make DESTDIR=$(CURDIR)/deb install

debug:
	@echo "${PACKAGE}"
	@echo "${VERSION}"
	@echo "${PACKAGE_BUGREPORT}"