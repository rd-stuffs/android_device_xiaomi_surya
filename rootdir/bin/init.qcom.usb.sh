#!/vendor/bin/sh
# Copyright (C) 2024 Paranoid Android
# SPDX-License-Identifier: Apache-2.0

# Set platform variables
soc_hwplatform=`cat /sys/devices/soc0/hw_platform 2> /dev/null`
soc_machine=`cat /sys/devices/soc0/machine 2> /dev/null`
soc_machine=${soc_machine:0:2}
soc_id=`cat /sys/devices/soc0/soc_id 2> /dev/null`

#
# Check ESOC for external modem
#
# Note: currently only a single MDM/SDX is supported
#
esoc_name=`cat /sys/bus/esoc/devices/esoc0/esoc_name 2> /dev/null`

target=`getprop ro.board.platform`

#
# Override USB default composition
#
# If USB persist config not set, set default configuration

debuggable=`getprop ro.debuggable`

if [ "$(getprop persist.vendor.usb.config)" == "diag,serial_cdev,rmnet,dpl,qdss,adb" \
	-o "$(getprop persist.vendor.usb.config)" == "" -a "$(getprop ro.build.type)" != "user" -a \
	"$(getprop init.svc.vendor.usb-gadget-hal-1-0)" != "running" ]; then
    if [ "$esoc_name" != "" ]; then
	  setprop persist.vendor.usb.config diag,diag_mdm,qdss,qdss_mdm,serial_cdev,dpl,rmnet,adb
    else
	  case "$(getprop ro.baseband)" in
	      "apq")
	          setprop persist.vendor.usb.config diag,adb
	      ;;
	      *)
	      case "$soc_hwplatform" in
	          "Dragon" | "SBC")
	              setprop persist.vendor.usb.config diag,adb
	          ;;
                  *)
		  case "$soc_machine" in
		    "SA")
	              setprop persist.vendor.usb.config diag,adb
		    ;;
		    *)
	            case "$target" in
	              "msm8996")
	                  setprop persist.vendor.usb.config diag,serial_cdev,serial_tty,rmnet_ipa,mass_storage,adb
		      ;;
	              "msm8909")
		          setprop persist.vendor.usb.config diag,serial_smd,rmnet_qti_bam,adb
		      ;;
	              "msm8937")
			    if [ -d /config/usb_gadget ]; then
				       setprop persist.vendor.usb.config diag,serial_cdev,rmnet,dpl,adb
			    else
			               case "$soc_id" in
				               "313" | "320")
				                  setprop persist.vendor.usb.config diag,serial_smd,rmnet_ipa,adb
				               ;;
				               *)
				                  setprop persist.vendor.usb.config diag,serial_smd,rmnet_qti_bam,adb
				               ;;
			               esac
			    fi
		      ;;
	              "msm8953")
			      if [ -d /config/usb_gadget ]; then
				      setprop persist.vendor.usb.config diag,serial_cdev,rmnet,dpl,adb
			      else
				      setprop persist.vendor.usb.config diag,serial_smd,rmnet_ipa,adb
			      fi
		      ;;
	              "msm8998" | "sdm660" | "apq8098_latv")
		          setprop persist.vendor.usb.config diag,serial_cdev,rmnet,adb
		      ;;
	              "sdm845" | "sdm710")
		          setprop persist.vendor.usb.config diag,serial_cdev,rmnet,dpl,adb
		      ;;
	              "msmnile" | "sm6150" | "trinket" | "lito" | "atoll" | "bengal" | "lahaina" | "holi" | "curtana" | "gram" | "excalibur" | "joyeuse" | "surya")
                      case "$debuggable" in
                      "1")
				setprop persist.vendor.usb.config adb
                             ;;
                             *)
				setprop persist.vendor.usb.config none
                             ;;
                      esac
		      ;;
	              "monaco")
		          setprop persist.vendor.usb.config diag,qdss,rmnet,adb
		      ;;
	              *)
		          setprop persist.vendor.usb.config diag,adb
		      ;;
                    esac
		    ;;
		  esac
	          ;;
	      esac
	      ;;
	  esac
      fi
fi

# This check is needed for GKI 1.0 targets where QDSS is not available
if [ "$(getprop persist.vendor.usb.config)" == "diag,serial_cdev,rmnet,dpl,qdss,adb" -a \
     ! -d /config/usb_gadget/g1/functions/qdss.qdss ]; then
      setprop persist.vendor.usb.config diag,serial_cdev,rmnet,dpl,adb
fi

# Start peripheral mode on primary USB controllers for Automotive platforms
case "$soc_machine" in
    "SA")
	if [ -f /sys/bus/platform/devices/a600000.ssusb/mode ]; then
	    default_mode=`cat /sys/bus/platform/devices/a600000.ssusb/mode`
	    case "$default_mode" in
		"none")
		    echo peripheral > /sys/bus/platform/devices/a600000.ssusb/mode
		;;
	    esac
	fi
    ;;
esac

# check configfs is mounted or not
if [ -d /config/usb_gadget ]; then
	# Chip-serial is used for unique MSM identification in Product string
	msm_serial=`cat /sys/devices/soc0/serial_number`;
	# If MSM serial number is not available, then keep it blank instead of 0x00000000
	if [ "$msm_serial" != "" ]; then
		msm_serial_hex=`printf %08X $msm_serial`
	fi

	machine_type=`cat /sys/devices/soc0/machine`
	setprop vendor.usb.product_string "$machine_type-$soc_hwplatform _SN:$msm_serial_hex"

	# ADB requires valid iSerialNumber; if ro.serialno is missing, use dummy
	serialnumber=`cat /config/usb_gadget/g1/strings/0x409/serialnumber 2> /dev/null`
	if [ "$serialnumber" == "" ]; then
		serialno=1234567
		echo $serialno > /config/usb_gadget/g1/strings/0x409/serialnumber
	fi
	setprop vendor.usb.configfs 1
fi

# update product
marketname=`getprop ro.product.marketname`
if [ "$marketname" != "" ]; then
    setprop vendor.usb.product_string "$marketname"
else
    setprop vendor.usb.product_string "$(getprop ro.product.model)"
fi

#
# Initialize RNDIS Diag option. If unset, set it to 'none'.
#
diag_extra=`getprop persist.vendor.usb.config.extra`
if [ "$diag_extra" == "" ]; then
	setprop persist.vendor.usb.config.extra none
fi

# enable rps cpus on msm8937 target
setprop vendor.usb.rps_mask 0
case "$soc_id" in
	"294" | "295" | "353" | "354")
		setprop vendor.usb.rps_mask 40
	;;
esac

#
# Initialize UVC conifguration.
#
if [ -d /config/usb_gadget/g1/functions/uvc.0 ]; then
	cd /config/usb_gadget/g1/functions/uvc.0

	echo 3072 > streaming_maxpacket
	echo 1 > streaming_maxburst
	mkdir control/header/h
	ln -s control/header/h control/class/fs/
	ln -s control/header/h control/class/ss

	mkdir -p streaming/uncompressed/u/360p
	echo "666666\n1000000\n5000000\n" > streaming/uncompressed/u/360p/dwFrameInterval

	mkdir -p streaming/uncompressed/u/720p
	echo 1280 > streaming/uncompressed/u/720p/wWidth
	echo 720 > streaming/uncompressed/u/720p/wWidth
	echo 29491200 > streaming/uncompressed/u/720p/dwMinBitRate
	echo 29491200 > streaming/uncompressed/u/720p/dwMaxBitRate
	echo 1843200 > streaming/uncompressed/u/720p/dwMaxVideoFrameBufferSize
	echo 5000000 > streaming/uncompressed/u/720p/dwDefaultFrameInterval
	echo "5000000\n" > streaming/uncompressed/u/720p/dwFrameInterval

	mkdir -p streaming/mjpeg/m/360p
	echo "666666\n1000000\n5000000\n" > streaming/mjpeg/m/360p/dwFrameInterval

	mkdir -p streaming/mjpeg/m/720p
	echo 1280 > streaming/mjpeg/m/720p/wWidth
	echo 720 > streaming/mjpeg/m/720p/wWidth
	echo 29491200 > streaming/mjpeg/m/720p/dwMinBitRate
	echo 29491200 > streaming/mjpeg/m/720p/dwMaxBitRate
	echo 1843200 > streaming/mjpeg/m/720p/dwMaxVideoFrameBufferSize
	echo 5000000 > streaming/mjpeg/m/720p/dwDefaultFrameInterval
	echo "5000000\n" > streaming/mjpeg/m/720p/dwFrameInterval

	echo 0x04 > /config/usb_gadget/g1/functions/uvc.0/streaming/mjpeg/m/bmaControls

	mkdir -p streaming/h264/h/960p
	echo 1920 > streaming/h264/h/960p/wWidth
	echo 960 > streaming/h264/h/960p/wWidth
	echo 40 > streaming/h264/h/960p/bLevelIDC
	echo "333667\n" > streaming/h264/h/960p/dwFrameInterval

	mkdir -p streaming/h264/h/1920p
	echo "333667\n" > streaming/h264/h/1920p/dwFrameInterval

	mkdir streaming/header/h
	ln -s streaming/uncompressed/u streaming/header/h
	ln -s streaming/mjpeg/m streaming/header/h
	ln -s streaming/h264/h streaming/header/h
	ln -s streaming/header/h streaming/class/fs/
	ln -s streaming/header/h streaming/class/hs/
	ln -s streaming/header/h streaming/class/ss/
fi
