// Copyright (C) 2023 Paranoid Android
// SPDX-License-Identifier: Apache-2.0

#include <vector>

#include <android-base/logging.h>
#include <android-base/properties.h>
#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>
#include <sys/sysinfo.h>

using android::base::GetProperty;

std::string hwname = GetProperty("ro.boot.hwname", "");

void property_override(char const prop[], char const value[], bool add = true) {
    prop_info* pi;

    pi = (prop_info*)__system_property_find(prop);
    if (pi)
        __system_property_update(pi, value, strlen(value));
    else if (add)
        __system_property_add(prop, strlen(prop), value, strlen(value));
}

void load_poco_karna() {
    property_override("ro.product.device", "karna");
    property_override("ro.product.model", "POCO X3");
    property_override("ro.product.name", "karna_in");
}

void vendor_load_properties() {
    if (access("/system/bin/recovery", F_OK) != 0) {
        if (hwname == "karna") {
            load_poco_karna();
        }
    }

    // Set hardware revision
    property_override("ro.boot.hardware.revision", GetProperty("ro.boot.hwversion", "").c_str());
}
