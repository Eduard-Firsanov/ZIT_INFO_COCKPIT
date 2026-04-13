*******************************************************************
*   System-defined Include-files.                                 *
*******************************************************************
  INCLUDE lzre_pm_cockpittop.              " Global Data
  INCLUDE lzre_pm_cockpituxx.              " Function Modules

*******************************************************************
*   User-defined Include-files (if necessary).                    *
*******************************************************************
* INCLUDE /DATRAIN/LKC_MAINF...              " Subprograms
* INCLUDE /DATRAIN/LKC_MAINO...              " PBO-Modules
* INCLUDE /DATRAIN/LKC_MAINI...              " PAI-Modules


* ProcessBeforeOutput-Module
  INCLUDE lzre_pm_cockpitpbo.
*INCLUDE /DATRAIN/LKC_MAIN_2008PBO.
*INCLUDE /DATRAIN/LKC_MAINPBO.

* ProcessAfterInput-Module
  INCLUDE lzre_pm_cockpitpai.
*INCLUDE /DATRAIN/LKC_MAIN_2008PAI.
*INCLUDE /DATRAIN/LKC_MAINPAI.

* Unterprogramme
  INCLUDE lzre_pm_cockpitf01.
*INCLUDE /DATRAIN/LKC_MAIN_2008F01.
*INCLUDE /DATRAIN/LKC_MAINF01.

* noch mehr Unterprogramme (Unterprogramme für ALV)
  INCLUDE lzre_pm_cockpitf02.
*INCLUDE /DATRAIN/LKC_MAIN_2008F02.
*INCLUDE /DATRAIN/LKC_MAINF02.

* PBO- und PAI-Module und Unterprogramme für TableControls
*INCLUDE /DATRAIN/LKC_MAIN_2008TAB.

*&SPWizard: Include inserted by SP Wizard. DO NOT CHANGE THIS LINE!
  INCLUDE lzre_pm_cockpito01 .
  INCLUDE lzre_pm_cockpiti01 .

*INCLUDE lzre_pm_cockpitd01.
