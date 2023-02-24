ifeq ($(J20C_SEPOLICY_INCLUDED),)

SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += \
    device/xiaomi/surya/sepolicy/common/private

BOARD_VENDOR_SEPOLICY_DIRS += \
    device/xiaomi/surya/sepolicy/audio/vendor \
    device/xiaomi/surya/sepolicy/batterysecret/vendor \
    device/xiaomi/surya/sepolicy/power/vendor \
    device/xiaomi/surya/sepolicy/camera/vendor \
    device/xiaomi/surya/sepolicy/common/vendor \
    device/xiaomi/surya/sepolicy/ir/vendor \
    device/xiaomi/surya/sepolicy/fingerprint/vendor \
    device/xiaomi/surya/sepolicy/leds/vendor \
    device/xiaomi/surya/sepolicy/qcom-extra/vendor \
    device/xiaomi/surya/sepolicy/thermal/vendor

J20C_SEPOLICY_INCLUDED := true
endif
