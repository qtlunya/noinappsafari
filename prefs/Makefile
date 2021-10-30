ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = NoInAppSafariPrefs

NoInAppSafariPrefs_FILES = NISRootListController.m
NoInAppSafariPrefs_FRAMEWORKS = UIKit
NoInAppSafariPrefs_PRIVATE_FRAMEWORKS = Preferences
NoInAppSafariPrefs_INSTALL_PATH = /Library/PreferenceBundles
NoInAppSafariPrefs_CFLAGS = -fobjc-arc
NoInAppSafariPrefs_LIBRARIES = applist

include $(THEOS_MAKE_PATH)/bundle.mk
