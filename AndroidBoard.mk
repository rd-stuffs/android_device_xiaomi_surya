# Kernel headers
$(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr: $(wildcard device/xiaomi/surya-kernel/kernel-headers/*)
	rm -rf $@
	cp -a device/xiaomi/surya-kernel/kernel-headers/. $@
