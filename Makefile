ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NoInAppSafari

NoInAppSafari_FILES = Tweak.xm
NoInAppSafari_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
