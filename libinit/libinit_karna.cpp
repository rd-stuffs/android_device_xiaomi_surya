// Copyright (C) 2024 Paranoid Android
// SPDX-License-Identifier: Apache-2.0

#include <vector>
#include <android-base/properties.h>
#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>
#include <sys/sysinfo.h>

using android::base::GetProperty;

void property_override(char const prop[], char const value[], bool add = true) {
    prop_info* pi;
    pi = (prop_info*)__system_property_find(prop);
    if (pi)
        __system_property_update(pi, value, strlen(value));
    else if (add)
        __system_property_add(prop, strlen(prop), value, strlen(value));
}

void load_poco_karna() {
    property_override("ro.boot.hardware.sku", "karna");
    property_override("ro.product.device", "karna");
    property_override("ro.product.model", "POCO X3");
    property_override("ro.product.name", "karna_in");
}

void vendor_load_properties() {
    std::string hwname = GetProperty("ro.boot.hwname", "");
    if (hwname == "karna")
        load_poco_karna();
}
