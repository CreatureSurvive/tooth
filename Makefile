TARGET = iphone:clang:13.0:7.0
ARCHS = armv7 armv7s arm64 arm64e

PACKAGE_VERSION = 1.1.3
GO_EASY_ON_ME = 0
LEAN_AND_MEAN = 1
FINALPACKAGE = 1
DEBUG = 0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Tooth
Tooth_FILES = $(wildcard *.m) $(wildcard BluetoothManager/*.m)
Tooth_PRIVATE_FRAMEWORKS = BluetoothManager
Tooth_FRAMEWORKS = UIKit
Tooth_CFLAGS +=  -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

BUNDLE_NAME = ToothSupport
ToothSupport_BUNDLE_EXTENSION = bundle
ToothSupport_INSTALL_PATH = /var/mobile/Library/Application Support/

include $(THEOS_MAKE_PATH)/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"
