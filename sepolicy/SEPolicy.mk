# Copyright (C) 2024 Paranoid Android
# SPDX-License-Identifier: Apache-2.0

SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += \
    $(DEVICE_PATH)/sepolicy/common/private

BOARD_VENDOR_SEPOLICY_DIRS += \
    $(DEVICE_PATH)/sepolicy/camera/vendor \
    $(DEVICE_PATH)/sepolicy/common/vendor \
    $(DEVICE_PATH)/sepolicy/fingerprint/vendor \
    $(DEVICE_PATH)/sepolicy/power/vendor
