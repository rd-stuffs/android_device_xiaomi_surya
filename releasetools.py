# Copyright (C) 2023 Paranoid Android
# SPDX-License-Identifier: Apache-2.0

import common
import re

def FullOTA_InstallEnd(info):
  input_zip = info.input_zip
  OTA_InstallEnd(info, input_zip)
  return

def AddImage(info, input_zip, basename, dest):
  name = basename
  data = input_zip.read("IMAGES/" + basename)
  common.ZipWriteStr(info.output_zip, name, data)
  info.script.Print("Patching {} image unconditionally...".format(dest.split('/')[-1]))
  info.script.AppendExtra('package_extract_file("%s", "%s");' % (name, dest))

def AddImageRadio(info, input_zip, basename, dest):
  name = basename
  data = input_zip.read("RADIO/" + basename)
  common.ZipWriteStr(info.output_zip, name, data)
  info.script.Print("Patching {} image unconditionally...".format(dest.split('/')[-1]))
  info.script.AppendExtra('package_extract_file("%s", "%s");' % (name, dest))

def OTA_InstallEnd(info, input_zip):
  AddImage(info, input_zip, "dtbo.img", "/dev/block/bootdevice/by-name/dtbo")
  AddImage(info, input_zip, "recovery.img", "/dev/block/bootdevice/by-name/recovery")
  AddImage(info, input_zip, "vbmeta.img", "/dev/block/bootdevice/by-name/vbmeta")
  AddImage(info, input_zip, "vbmeta_system.img", "/dev/block/bootdevice/by-name/vbmeta_system")
  AddImageRadio(info, input_zip, "abl.elf", "/dev/block/bootdevice/by-name/abl")
  AddImageRadio(info, input_zip, "aop.mbn", "/dev/block/bootdevice/by-name/aop")
  AddImageRadio(info, input_zip, "BTFM.bin", "/dev/block/bootdevice/by-name/bluetooth")
  AddImageRadio(info, input_zip, "cmnlib.mbn", "/dev/block/bootdevice/by-name/cmnlib")
  AddImageRadio(info, input_zip, "cmnlib64.mbn", "/dev/block/bootdevice/by-name/cmnlib64")
  AddImageRadio(info, input_zip, "devcfg.mbn", "/dev/block/bootdevice/by-name/devcfg")
  AddImageRadio(info, input_zip, "dspso.bin", "/dev/block/bootdevice/by-name/dsp")
  AddImageRadio(info, input_zip, "ffu.img", "/dev/block/bootdevice/by-name/ffu")
  AddImageRadio(info, input_zip, "hyp.mbn", "/dev/block/bootdevice/by-name/hyp")
  AddImageRadio(info, input_zip, "imagefv.elf", "/dev/block/bootdevice/by-name/imagefv")
  AddImageRadio(info, input_zip, "km4.mbn", "/dev/block/bootdevice/by-name/keymaster")
  AddImageRadio(info, input_zip, "NON-HLOS.bin", "/dev/block/bootdevice/by-name/modem")
  AddImageRadio(info, input_zip, "qupv3fw.elf", "/dev/block/bootdevice/by-name/qupfw")
  AddImageRadio(info, input_zip, "storsec.mbn", "/dev/block/bootdevice/by-name/storsec")
  AddImageRadio(info, input_zip, "tz.mbn", "/dev/block/bootdevice/by-name/tz")
  AddImageRadio(info, input_zip, "uefi_sec.mbn", "/dev/block/bootdevice/by-name/uefisecapp")
  AddImageRadio(info, input_zip, "xbl.elf", "/dev/block/bootdevice/by-name/xbl")
  AddImageRadio(info, input_zip, "xbl_config.elf", "/dev/block/bootdevice/by-name/xbl_config")
  info.script.AppendExtra('run_program("/system/bin/rm", "-rf", "/data/system/package_cache");')
  return
