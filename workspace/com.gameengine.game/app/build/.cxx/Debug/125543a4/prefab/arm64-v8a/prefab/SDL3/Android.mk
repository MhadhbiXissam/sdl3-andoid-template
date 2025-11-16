LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_ARCH_ABI),arm64-v8a)

include $(CLEAR_VARS)
LOCAL_MODULE := Headers
LOCAL_EXPORT_C_INCLUDES := /root/.gradle/caches/8.12/transforms/03d2612a8079f5e70829bbffecb51cf1/transformed/SDL3-3.2.26/prefab/modules/Headers/include
LOCAL_EXPORT_SHARED_LIBRARIES :=
LOCAL_EXPORT_STATIC_LIBRARIES := SDL3-Headers
LOCAL_EXPORT_LDLIBS :=
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := SDL3
LOCAL_EXPORT_C_INCLUDES := /root/.gradle/caches/8.12/transforms/03d2612a8079f5e70829bbffecb51cf1/transformed/SDL3-3.2.26/prefab/modules/SDL3/include
LOCAL_EXPORT_SHARED_LIBRARIES := SDL3-shared
LOCAL_EXPORT_STATIC_LIBRARIES :=
LOCAL_EXPORT_LDLIBS :=
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := SDL3-Headers
LOCAL_EXPORT_C_INCLUDES := /root/.gradle/caches/8.12/transforms/03d2612a8079f5e70829bbffecb51cf1/transformed/SDL3-3.2.26/prefab/modules/SDL3-Headers/include
LOCAL_EXPORT_SHARED_LIBRARIES :=
LOCAL_EXPORT_STATIC_LIBRARIES :=
LOCAL_EXPORT_LDLIBS :=
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := SDL3-shared
LOCAL_SRC_FILES := /root/.gradle/caches/8.12/transforms/03d2612a8079f5e70829bbffecb51cf1/transformed/SDL3-3.2.26/prefab/modules/SDL3-shared/libs/android.arm64-v8a/libSDL3.so
LOCAL_EXPORT_C_INCLUDES := /root/.gradle/caches/8.12/transforms/03d2612a8079f5e70829bbffecb51cf1/transformed/SDL3-3.2.26/prefab/modules/SDL3-shared/include
LOCAL_EXPORT_SHARED_LIBRARIES :=
LOCAL_EXPORT_STATIC_LIBRARIES := Headers
LOCAL_EXPORT_LDLIBS :=
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := SDL3_test
LOCAL_SRC_FILES := /root/.gradle/caches/8.12/transforms/03d2612a8079f5e70829bbffecb51cf1/transformed/SDL3-3.2.26/prefab/modules/SDL3_test/libs/android.arm64-v8a/libSDL3_test.a
LOCAL_EXPORT_C_INCLUDES := /root/.gradle/caches/8.12/transforms/03d2612a8079f5e70829bbffecb51cf1/transformed/SDL3-3.2.26/prefab/modules/SDL3_test/include
LOCAL_EXPORT_SHARED_LIBRARIES :=
LOCAL_EXPORT_STATIC_LIBRARIES := Headers
LOCAL_EXPORT_LDLIBS :=
include $(PREBUILT_STATIC_LIBRARY)

endif  # arm64-v8a

