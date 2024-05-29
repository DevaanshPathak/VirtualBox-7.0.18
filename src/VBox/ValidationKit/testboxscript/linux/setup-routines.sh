#!/bin/sh
# $Id: setup-routines.sh $
## @file
# VirtualBox Validation Kit - TestBoxScript Service Setup.
#

#
# Copyright (C) 2006-2023 Oracle and/or its affiliates.
#
# This file is part of VirtualBox base platform packages, as
# available from https://www.virtualbox.org.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation, in version 3 of the
# License.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, see <https://www.gnu.org/licenses>.
#
# The contents of this file may alternatively be used under the terms
# of the Common Development and Distribution License Version 1.0
# (CDDL), a copy of it is provided in the "COPYING.CDDL" file included
# in the VirtualBox distribution, in which case the provisions of the
# CDDL are applicable instead of those of the GPL.
#
# You may elect to license modified versions of this file under the
# terms and conditions of either the GPL or the CDDL or both.
#
# SPDX-License-Identifier: GPL-3.0-only OR CDDL-1.0
#


# Load the routines we share with the linux installer.
if test ! -r "${DIR}/linux/setup-installer-routines.sh" -a -r "${DIR}/../../Installer/linux/routines.sh"; then
    . "${DIR}/../../Installer/linux/routines.sh"
else
    . "${DIR}/linux/setup-installer-routines.sh"
fi


os_load_config() {
    if [ -d /etc/conf.d/ ]; then
        MY_CONFIG_FILE="/etc/conf.d/testboxscript"
    elif [ -d /etc/default/ ]; then
        MY_CONFIG_FILE="/etc/default/testboxscript"
    else
        echo "Port me!"
        exit 1;
    fi
    if [ -r "${MY_CONFIG_FILE}" ]; then
        . "${MY_CONFIG_FILE}"
    fi
}

os_install_service() {
    #
    # Install the runlevel script.
    #
    install_init_script "${TESTBOXSCRIPT_DIR}/testboxscript/linux/testboxscript-service.sh" "testboxscript-service"
    set +e
    delrunlevel "testboxscript-service" > /dev/null 2>&1
    addrunlevel "testboxscript-service" 90 10
    set -e

    #
    # Install the configuration file.
    #
    echo "# Generated by $0." >  "${MY_CONFIG_FILE}"
    for var in ${TESTBOXSCRIPT_CFG_NAMES};
    do
        varcfg=TESTBOXSCRIPT_${var}
        vardef=TESTBOXSCRIPT_DEFAULT_${var}
        if [ "${!varcfg}" = "${!vardef}" ]; then
            echo "# using default value: ${varcfg}=${!varcfg}" >> "${MY_CONFIG_FILE}"
        else
            echo "${varcfg}=${!varcfg}" >> "${MY_CONFIG_FILE}"
        fi
    done

    # Work around a bug with arrays in old bash versions.
    if [ ${#TESTBOXSCRIPT_ENVVARS[@]} -ne 0 ]; then
        set | sed -n -e '/^TESTBOXSCRIPT_ENVVARS=/p' >> "${MY_CONFIG_FILE}"
    fi
    return 0;
}

os_enable_service() {
    start_init_script testboxscript-service
    return 0;
}

os_disable_service() {
    stop_init_script testboxscript-service 2>&1 || true # Ignore
    return 0;
}

os_add_user() {
    ADD_GROUPS=""
    if ! grep -q wheel /etc/group; then
        ADD_GROUPS="-G wheel"
    fi
    set -e
    useradd -m -U -p password -s /bin/bash ${ADD_GROUPS} "${TESTBOXSCRIPT_USER}"
    set +e
    return 0;
}

check_for_cifs() {
    test -x /sbin/mount.cifs -o -x /usr/sbin/mount.cifs
    grep -wq cifs /proc/filesystems || modprobe cifs;
    # Note! If modprobe doesn't work above, /sbin and /usr/sbin are probably missing from the search PATH.
    return 0;
}

##
# Test if core dumps are enabled. See https://wiki.ubuntu.com/Apport!
#
test_coredumps() {
    if test "`lsb_release -is`" = "Ubuntu"; then
        if grep -q "apport" /proc/sys/kernel/core_pattern; then
            if grep -q "#.*problem_types" /etc/apport/crashdb.conf; then
                echo "It looks like core dumps are properly configured, good!"
            else
                echo "Warning: Core dumps will be not always generated!"
            fi
        else
            echo "Warning: Apport not installed! This package is required for core dump handling!"
        fi
    fi
}

##
# Test if unattended updates are disabled. See
#   http://ask.xmodulo.com/disable-automatic-updates-ubuntu.html
test_unattended_updates_disabled() {
    if grep "APT::Periodic::Unattended-Upgrade.*1" /etc/apt/apt.conf.d/* 2>/dev/null; then
        echo "Unattended updates enabled?"
        return 1
    fi
    if grep "APT::Periodic::Update-Package-List.*1" /etc/apt/apt.conf.d/* 2>/dev/null; then
        echo "Unattended package updates enabled?"
        return 1
    fi
}

os_final_message() {
    cat <<EOF

Additional things to do:"
    1. Check if the proxy settings are appropriate for reaching the test
       manager host. Python does not support domain matches starting with ".".

       For Debian and Ubuntu: check /etc/environment.
       For EL: check /etc/profile and/or the files in /etc/profile.d/.

    2. If the system should be doing RAM disk based testing, add the following
       (or something similar, adapted to the system) to /etc/fstab:

         tmpfs /var/tmp/testbox-1000 tmpfs defaults,size=16G 0 0

After making such adjustments, it's the easiest solution to reboot the testbox.

Enjoy!
EOF
}

