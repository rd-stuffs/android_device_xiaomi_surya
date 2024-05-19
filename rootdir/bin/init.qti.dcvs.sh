#!/vendor/bin/sh

# Copyright (C) 2024 Paranoid Android
# SPDX-License-Identifier: Apache-2.0

# Enable bus-dcvs
for device in /sys/devices/platform/soc; do
    for cpubw in $device/*cpu-cpu-llcc-bw/devfreq/*cpu-cpu-llcc-bw; do
        echo "bw_hwmon" > $cpubw/governor
        echo "2288 4577 7110 9155 12298 14236" > $cpubw/bw_hwmon/mbps_zones
        echo 4 > $cpubw/bw_hwmon/sample_ms
        echo 68 > $cpubw/bw_hwmon/io_percent
        echo 20 > $cpubw/bw_hwmon/hist_memory
        echo 0 > $cpubw/bw_hwmon/hyst_length
        echo 80 > $cpubw/bw_hwmon/down_thres
        echo 0 > $cpubw/bw_hwmon/guard_band_mbps
        echo 250 > $cpubw/bw_hwmon/up_scale
        echo 1600 > $cpubw/bw_hwmon/idle_mbps
        echo 50 > $cpubw/polling_interval
    done

    for llccbw in $device/*cpu-llcc-ddr-bw/devfreq/*cpu-llcc-ddr-bw; do
        echo "bw_hwmon" > $llccbw/governor
        echo "1144 1720 2086 2929 3879 5931 6881" > $llccbw/bw_hwmon/mbps_zones
        echo 4 > $llccbw/bw_hwmon/sample_ms
        echo 68 > $llccbw/bw_hwmon/io_percent
        echo 20 > $llccbw/bw_hwmon/hist_memory
        echo 0 > $llccbw/bw_hwmon/hyst_length
        echo 80 > $llccbw/bw_hwmon/down_thres
        echo 0 > $llccbw/bw_hwmon/guard_band_mbps
        echo 250 > $llccbw/bw_hwmon/up_scale
        echo 1600 > $llccbw/bw_hwmon/idle_mbps
        echo 40 > $llccbw/polling_interval
    done

    for npubw in $device/*npu-npu-ddr-bw/devfreq/*npu-npu-ddr-bw; do
        echo 1 > /sys/devices/virtual/npu/msm_npu/pwr
        echo "bw_hwmon" > $npubw/governor
        echo "1144 1720 2086 2929 3879 5931 6881" > $npubw/bw_hwmon/mbps_zones
        echo 4 > $npubw/bw_hwmon/sample_ms
        echo 80 > $npubw/bw_hwmon/io_percent
        echo 20 > $npubw/bw_hwmon/hist_memory
        echo 10 > $npubw/bw_hwmon/hyst_length
        echo 30 > $npubw/bw_hwmon/down_thres
        echo 0 > $npubw/bw_hwmon/guard_band_mbps
        echo 250 > $npubw/bw_hwmon/up_scale
        echo 0 > $npubw/bw_hwmon/idle_mbps
        echo 40 > $npubw/polling_interval
        echo 0 > /sys/devices/virtual/npu/msm_npu/pwr
    done

    # Enable mem_latency governor for L3, LLCC, and DDR scaling
    for memlat in $device/*cpu*-lat/devfreq/*cpu*-lat; do
        echo "mem_latency" > $memlat/governor
        echo 10 > $memlat/polling_interval
        echo 400 > $memlat/mem_latency/ratio_ceil
    done

    # Gold L3 ratio ceil
    echo 4000 > /sys/class/devfreq/soc:qcom,cpu6-cpu-l3-lat/mem_latency/ratio_ceil

    # Enable cdspl3 governor for L3 cdsp nodes
    for l3cdsp in $device/*cdsp-cdsp-l3-lat/devfreq/*cdsp-cdsp-l3-lat; do
        echo "cdspl3" > $l3cdsp/governor
    done

    # Enable compute governor for gold latfloor
    for latfloor in $device/*cpu*-ddr-latfloor*/devfreq/*cpu-ddr-latfloor*; do
        echo "compute" > $latfloor/governor
        echo 10 > $latfloor/polling_interval
    done
done
