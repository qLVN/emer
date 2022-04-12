export ARCHS=arm64 arm64e
export SDKVERSION=13.0
TARGET=iphone:clang::13.0

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Emer

Emer_FILES = Emer.xm EmerController.m EmerWidgetController.m emerprefs/EmerConfigHeaderUpdater.m emerprefs/EmerConfigHeaderView.m
Emer_CFLAGS = -fobjc-arc
Emer_FRAMEWORKS = UIKit
Emer_LIBRARIES = sparkcolourpicker

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += emerprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
