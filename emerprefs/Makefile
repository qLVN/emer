include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = emerPrefs

emerPrefs_FILES = EMRRootListController.m EmerConfigHeaderView.m EmerConfigHeaderUpdater.m
emerPrefs_INSTALL_PATH = /Library/PreferenceBundles
emerPrefs_FRAMEWORKS = UIKit
emerPrefs_PRIVATE_FRAMEWORKS = Preferences
emerPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/emerPrefs.plist$(ECHO_END)
