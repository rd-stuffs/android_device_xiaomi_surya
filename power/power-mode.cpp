// Copyright (C) 2023 Paranoid Android
// SPDX-License-Identifier: Apache-2.0

#include <aidl/android/hardware/power/BnPower.h>
#include <android-base/file.h>
#include "power-common.h"

#define DOUBLE_TAP_NODE "/sys/touchpanel/double_tap"

namespace aidl {
namespace android {
namespace hardware {
namespace power {
namespace impl {

using ::aidl::android::hardware::power::Mode;
using ::android::base::WriteStringToFile;

bool isDeviceSpecificModeSupported(Mode type, bool* _aidl_return) {
    switch (type) {
        case Mode::DOUBLE_TAP_TO_WAKE:
            *_aidl_return = true;
            return true;
        default:
            return false;
    }
}

bool setDeviceSpecificMode(Mode type, bool enabled) {
    switch (type) {
        case Mode::DOUBLE_TAP_TO_WAKE:
            WriteStringToFile(enabled ? "1" : "0", DOUBLE_TAP_NODE, true);
            return true;
        default:
            return false;
    }
}

}  // namespace impl
}  // namespace power
}  // namespace hardware
}  // namespace android
}  // namespace aidl
