/* $Id: UIWizardNewVDExpertPage.h $ */
/** @file
 * VBox Qt GUI - UIWizardNewVDExpertPage class declaration.
 */

/*
 * Copyright (C) 2006-2023 Oracle and/or its affiliates.
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
 * SPDX-License-Identifier: GPL-3.0-only
 */

#ifndef FEQT_INCLUDED_SRC_wizards_newvd_UIWizardNewVDExpertPage_h
#define FEQT_INCLUDED_SRC_wizards_newvd_UIWizardNewVDExpertPage_h
#ifndef RT_WITHOUT_PRAGMA_ONCE
# pragma once
#endif

/* GUI includes: */
#include "UINativeWizardPage.h"

/* Forward declarations: */
class QGroupBox;
class UIDiskFormatsComboBox;
class UIDiskVariantWidget;
class UIMediumSizeAndPathGroupBox;

/** Expert page of the New Virtual Hard Drive wizard. */
class SHARED_LIBRARY_STUFF UIWizardNewVDExpertPage : public UINativeWizardPage
{
    Q_OBJECT;

public:

    UIWizardNewVDExpertPage(const QString &strDefaultName, const QString &strDefaultPath, qulonglong uDefaultSize);

private slots:

    void sltMediumFormatChanged();
    void sltSelectLocationButtonClicked();
    void sltMediumVariantChanged(qulonglong uVariant);
    void sltMediumPathChanged(const QString &strPath);
    void sltMediumSizeChanged(qulonglong uSize);

private:

    /** Translation stuff. */
    void retranslateUi();

    /** Prepare stuff. */
    void prepare();
    void initializePage();

    /** Validation stuff. */
    bool isComplete() const;
    bool validatePage();
    void updateDiskWidgetsAfterMediumFormatChange();

   /** @name Widgets
     * @{ */
       UIMediumSizeAndPathGroupBox *m_pSizeAndPathGroup;
       UIDiskFormatsComboBox *m_pFormatComboBox;
       UIDiskVariantWidget *m_pVariantWidget;
       QGroupBox *m_pFormatVariantGroupBox;
   /** @} */

   /** @name Variable
     * @{ */
       QString m_strDefaultName;
       QString m_strDefaultPath;
       qulonglong m_uDefaultSize;
       qulonglong m_uMediumSizeMin;
       qulonglong m_uMediumSizeMax;
   /** @} */
};

#endif /* !FEQT_INCLUDED_SRC_wizards_newvd_UIWizardNewVDExpertPage_h */
