# Copyright (C) 2024 Paranoid Android
# SPDX-License-Identifier: Apache-2.0

import common
import re

def FullOTA_InstallEnd(info):
  input_zip = info.input_zip
  OTA_InstallEnd(info, input_zip)
  return

def AddImage(info, input_zip, basename, dest):
  name = basename
  path = "IMAGES/" + name
  if path not in input_zip.namelist():
    return

  data = input_zip.read(path)
  common.ZipWriteStr(info.output_zip, name, data)
  info.script.Print("Patching {} image unconditionally...".format(dest.split('/')[-1]))
  info.script.AppendExtra('package_extract_file("%s", "%s");' % (name, dest))

def OTA_InstallEnd(info, input_zip):
  AddImage(info, input_zip, "dtbo.img", "/dev/block/bootdevice/by-name/dtbo")
  AddImage(info, input_zip, "vbmeta.img", "/dev/block/bootdevice/by-name/vbmeta")
  AddImage(info, input_zip, "vbmeta_system.img", "/dev/block/bootdevice/by-name/vbmeta_system")
  return
