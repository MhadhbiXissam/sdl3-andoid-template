LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := main

# Add your application source files here...
LOCAL_SRC_FILES := \
    main.c

LOCAL_SHARED_LIBRARIES := SDL3 SDL3-Headers

include $(BUILD_SHARED_LIBRARY)

# https://google.github.io/prefab/build-systems.html

# Add the prefab modules to the import path.
$(call import-add-path,/out)

# Import SDL3 so we can depend on it.
$(call import-module,prefab/SDL3)
