TARGET = iphone:clang:13.0:13.0
ARCHS = arm64 arm64e
# INSTALL_TARGET_PROCESSES = Symbols
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = Symbols

Symbols_FILES = main.m SymbolsAppDelegate.m SymbolsRootViewController.m
Symbols_FRAMEWORKS = UIKit CoreGraphics
Symbols_CFLAGS = -fobjc-arc -Wdeprecated-declarations -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/application.mk

before-stage::
	find . -name ".DS\_Store" -delete

after-install::
	install.exec "uicache; killall -9 Symbols"
