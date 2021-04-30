TARGET = iphone:clang:13.0:13.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = Symbols
Symbols_FILES = $(wildcard *.m)
Symbols_FRAMEWORKS = UIKit CoreGraphics
Symbols_PRIVATE_FRAMEWORKS = CoreUI
Symbols_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/application.mk

before-stage::
	find . -name ".DS_Store" -delete

after-install::
	install.exec "uicache; killall -9 Symbols"
