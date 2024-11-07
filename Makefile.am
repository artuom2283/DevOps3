AUTOMAKE_OPTIONS = foreign
bin_PROGRAMS = myprogram
myprogram_SOURCES = main.cpp funcA.cpp funcA.h

PACKAGE = myprogram
VERSION = 1.0
PACKAGE_BUGREPORT = puzenko.artem@lll.kpi.ua

DEBIAN_DIR = $(CURDIR)/debian
CONTROL_FILE = $(DEBIAN_DIR)/control
DEB_PACKAGE_DIR = $(CURDIR)/deb

.PHONY: deb clean_deb debug

deb: clean_deb
  mkdir -p $(DEB_PACKAGE_DIR) $(DEBIAN_DIR)
  echo "Package: $(PACKAGE)" > $(CONTROL_FILE)
  echo "Version: $(VERSION)" >> $(CONTROL_FILE)
  echo "Section: base" >> $(CONTROL_FILE)
  echo "Priority: optional" >> $(CONTROL_FILE)
  echo "Architecture: all" >> $(CONTROL_FILE)
  echo "Maintainer: $(PACKAGE_BUGREPORT)" >> $(CONTROL_FILE)
  echo "Description: This is the $(PACKAGE) program." >> $(CONTROL_FILE)

  make DESTDIR=$(DEB_PACKAGE_DIR) install
  
  dpkg-deb --build $(DEB_PACKAGE_DIR) .

clean_deb:
  rm -rf $(DEB_PACKAGE_DIR)
  rm -rf $(DEBIAN_DIR)

debug:
  @echo "Package: ${PACKAGE}"
  @echo "Version: ${VERSION}"
  @echo "Maintainer: ${PACKAGE_BUGREPORT}"