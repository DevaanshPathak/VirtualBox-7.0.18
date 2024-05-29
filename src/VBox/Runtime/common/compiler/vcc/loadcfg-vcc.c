/* $Id: loadcfg-vcc.c $ */
/** @file
 * IPRT - Visual C++ Compiler - PE/Windows Load Configuration.
 *
 * @note This is a C file and not C++ because the compiler generates fixups
 *       that upsets the linker (ADDR32 + ADDR32_4 instead of ADDR64).
 */

/*
 * Copyright (C) 2022-2023 Oracle and/or its affiliates.
 *
 * This file is part of VirtualBox base platform packages, as
 * available from https://www.virtualbox.org.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation, in version 3 of the
 * License.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <https://www.gnu.org/licenses>.
 *
 * The contents of this file may alternatively be used under the terms
 * of the Common Development and Distribution License Version 1.0
 * (CDDL), a copy of it is provided in the "COPYING.CDDL" file included
 * in the VirtualBox distribution, in which case the provisions of the
 * CDDL are applicable instead of those of the GPL.
 *
 * You may elect to license modified versions of this file under the
 * terms and conditions of either the GPL or the CDDL or both.
 *
 * SPDX-License-Identifier: GPL-3.0-only OR CDDL-1.0
 */


/*********************************************************************************************************************************
*   Header Files                                                                                                                 *
*********************************************************************************************************************************/
#include "internal/iprt.h"
#include <iprt/formats/pecoff.h>

#include "internal/compiler-vcc.h"


/*********************************************************************************************************************************
*   Global Variables                                                                                                             *
*********************************************************************************************************************************/
extern uintptr_t    __security_cookie;          /**< nocrt-stack-win.asm */
#ifdef RT_ARCH_X86
extern uintptr_t    __safe_se_handler_table[];  /**< Linker generated. */
extern uint8_t      __safe_se_handler_count;    /**< Absolute "address" defined by the linker representing the table size. */
#endif
#ifdef RT_ARCH_AMD64
extern uintptr_t    __guard_dispatch_icall_fptr;/**< nocrt-guard-win.asm */
#endif
extern uintptr_t    __guard_fids_table[];       /**< Linker generated. */
extern uint8_t      __guard_fids_count;         /** Another absolute "address" generated by the linker for a table size. */
extern uint8_t      __guard_flags;              /** Another absolute "address" generated by the linker, flags value this time. */
extern uintptr_t    __guard_iat_table[];        /**< Linker generated. */
extern uint8_t      __guard_iat_count;          /** Another absolute "address" generated by the linker for a table size. */
extern uintptr_t    __guard_longjmp_table[];    /**< Linker generated. */
extern uint8_t      __guard_longjmp_count;      /** Another absolute "address" generated by the linker for a table size. */
extern uint8_t      __enclave_config;           /** Another absolute "address" generated by the linker, flags value this time. */
extern uintptr_t    __guard_eh_cont_table[];    /**< Linker generated. */
extern uint8_t      __guard_eh_cont_count;      /** Another absolute "address" generated by the linker for a table size. */
#ifdef RT_ARCH_AMD64
extern uintptr_t    __guard_xfg_check_icall_fptr;           /**< nocrt-guard-win.asm */
extern uintptr_t    __guard_xfg_dispatch_icall_fptr;        /**< nocrt-guard-win.asm */
extern uintptr_t    __guard_xfg_table_dispatch_icall_fptr;  /**< nocrt-guard-win.asm */
#endif


/**
 * The load configuration for the PE image.
 *
 * The name of this is dictated by the linker, as it looks for a
 * _load_config_used symbol and puts it's address and (somehow) size in the load
 * config data dir entry.
 *
 * @todo use _MSC_VER to reduce this for older linkers which doesn't support all
 *       the machinactions we include here for the 2019 (14.29.30139.0) linker.
 */
RT_CONCAT(IMAGE_LOAD_CONFIG_DIRECTORY, ARCH_BITS) const _load_config_used =
{
    /* .Size                                = */    sizeof(_load_config_used),
    /* .TimeDateStamp                       = */    0,
    /* .MajorVersion                        = */    0,
    /* .MinorVersion                        = */    0,
    /* .GlobalFlagsClear                    = */    0,
    /* .GlobalFlagsSet                      = */    0,
    /* .CriticalSectionDefaultTimeout       = */    0,
    /* .DeCommitFreeBlockThreshold          = */    0,
    /* .DeCommitTotalFreeThreshold          = */    0,
    /* .LockPrefixTable                     = */    0,
    /* .MaximumAllocationSize               = */    0,
    /* .VirtualMemoryThreshold              = */    0,
    /* .ProcessHeapFlags                    = */    0,
    /* .ProcessAffinityMask                 = */    0,
    /* .CSDVersion                          = */    0,
    /* .DependentLoadFlags                  = */    0,
    /* .EditList                            = */    0,
    /* .SecurityCookie                      = */    (uintptr_t)&__security_cookie,
#ifdef RT_ARCH_X86
    /* .SEHandlerTable                      = */    (uintptr_t)&__safe_se_handler_table[0],
    /* .SEHandlerCount                      = */    (uintptr_t)&__safe_se_handler_count,    /* Absolute "address", remember. */
#else
    /* .SEHandlerTable                      = */    0,
    /* .SEHandlerCount                      = */    0,
#endif
    /* .GuardCFCCheckFunctionPointer        = */    (uintptr_t)&__guard_check_icall_fptr,
#ifdef RT_ARCH_AMD64
    /* .GuardCFDispatchFunctionPointer      = */    (uintptr_t)&__guard_dispatch_icall_fptr,
#else
    /* .GuardCFDispatchFunctionPointer      = */    0,
#endif
    /* .GuardCFFunctionTable                = */    (uintptr_t)&__guard_fids_table[0],
    /* .GuardCFFunctionCount                = */    (uintptr_t)&__guard_fids_count,         /* Absolute "address", remember. */
    /* .GuardFlags                          = */    (uint32_t)(uintptr_t)&__guard_flags,    /* Ditto. */
    /* .CodeIntegrity                       = */    { 0, 0, 0, 0 },
    /* .GuardAddressTakenIatEntryTable      = */    (uintptr_t)__guard_iat_table,
    /* .GuardAddressTakenIatEntryCount      = */    (uintptr_t)&__guard_iat_count,          /* The same. */
    /* .GuardLongJumpTargetTable            = */    (uintptr_t)&__guard_longjmp_table[0],
    /* .GuardLongJumpTargetCount            = */    (uintptr_t)&__guard_longjmp_count,      /* Another one. */
    /* .DynamicValueRelocTable              = */    0,
    /* .CHPEMetadataPointer                 = */    0, /** @todo ARM */
    /* .GuardRFFailureRoutine               = */    0,
    /* .GuardRFFailureRoutineFunctionPointer= */    0,
    /* .DynamicValueRelocTableOffset        = */    0,
    /* .DynamicValueRelocTableSection       = */    0,
    /* .Reserved2                           = */    0,
    /* .GuardRFVerifyStackPointerFunctionPointer=*/ 0,
    /* .HotPatchTableOffset                 = */    0,
    /* .Reserved3                           = */    0,
    /* .EnclaveConfigurationPointer         = */    (uintptr_t)&__enclave_config,           /* And another one. */
    /* .VolatileMetadataPointer             = */    0,
    /* .GuardEHContinuationTable            = */    (uintptr_t)&__guard_eh_cont_table[0],
    /* .GuardEHContinuationCount            = */    (uintptr_t)&__guard_eh_cont_count,      /* Yet another one. */
#ifdef RT_ARCH_AMD64
    /* .GuardXFGCheckFunctionPointer        = */    (uintptr_t)&__guard_xfg_check_icall_fptr,
    /* .GuardXFGDispatchFunctionPointer     = */    (uintptr_t)&__guard_xfg_dispatch_icall_fptr,
    /* .GuardXFGTableDispatchFunctionPointer= */    (uintptr_t)&__guard_xfg_table_dispatch_icall_fptr,
#else
    /* .GuardXFGCheckFunctionPointer        = */    0,
    /* .GuardXFGDispatchFunctionPointer     = */    0,
    /* .GuardXFGTableDispatchFunctionPointer= */    0,
#endif
    /* .CastGuardOsDeterminedFailureMode    = */    0,
};

