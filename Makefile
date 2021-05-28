ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NoInAppSafari

NoInAppSafari_FILES = Tweak.xm
NoInAppSafari_CFLAGS = -fobjc-arc
NoInAppSafari_LIBRARIES = applist
NoInAppSafari_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += prefs
include $(THEOS_MAKE_PATH)/aggregate.mk
