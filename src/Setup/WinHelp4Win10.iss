
; Include parameters file if available
#ifexist SourcePath + "WinHelp4Win10.Params.iss"
  #include SourcePath + "WinHelp4Win10.Params.iss"
#endif

; Define general constants
#define MyAppName "WinHelp for Windows 10"
#define MyAppVersion "0.0.1"
#define MyBuildNo "0"
#define MyAppVerName MyAppName + " - v" + MyAppVersion

#define MsuFileName "Windows8.1-KB917607-x64.msu"
#define MsuDownloadUrl "https://download.microsoft.com/download/A/5/6/A5651A53-2487-43C6-835A-744EB9C72579/Windows8.1-KB917607-x64.msu"
#define WinHelpSrcDir "{tmp}\wh32src"
#define WinHelpSrcPrefix32 WinHelpSrcDir + "\x86_microsoft_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_"
#define WinHelpResSrcPrefix32 WinHelpSrcDir + "\x86_microsoft_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_"
#define WinHelpSrcPrefix64 WinHelpSrcDir + "\amd64_microsoft-windows-winhstb_31bf3856ad364e35_6.3.9600.20470_"
#define WinHelpResSrcPrefix64 WinHelpSrcDir + "\amd64_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_"

#define BinInputDir SourcePath + "..\..\bin"


#if defined(TestRelease)
  #define MyAppName   MyAppName + " " + TestRelease
#endif


[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId=WinHelp4Win10
AppName={#MyAppName}
AppVersion={#MyAppVersion}
VersionInfoVersion={#MyAppVersion}.{#MyBuildNo}
VersionInfoProductVersion={#MyAppVersion}.{#MyBuildNo}

AppVerName={#MyAppVerName}
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes
DisableReadyPage=no
ArchitecturesAllowed=x64 x86
ArchitecturesInstallIn64BitMode=x64
MinVersion=10.0

#ifndef TestRelease
Compression=lzma2
SolidCompression=Yes
#else
Compression=lzma2/fast
#endif

PrivilegesRequired=admin
OutputDir={#SourcePath}\Output
OutputBaseFilename=Setup_WinHelp4Win10
WizardStyle=modern
SetupIconFile=Setup.ico
UninstallDisplayIcon={app}\mywinhlp32.exe


[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"


[Files]
Source: "ExtractWinHelpFiles.cmd"; Flags: dontcopy
Source: "{#BinInputDir}\x64\*"; DestDir: "{app}"; Check: IsWin64
Source: "{#BinInputDir}\x86\*"; DestDir: "{app}"; Check: not IsWin64

// 64 Bit WinHelp files
Source: "{#WinHelpSrcPrefix64}none_1a54d9f2f676f6c2\*.dll"; DestDir: "{app}"; Flags: ignoreversion external; Check: IsWin64
Source: "{#WinHelpSrcPrefix64}none_1a54d9f2f676f6c2\winhlp32.exe"; DestDir: "{app}"; DestName: "mywinhlp32.exe"; Flags: ignoreversion external; Check: IsWin64
Source: "{#WinHelpResSrcPrefix64}ar-sa_2f09ffba55ebaab5\*.dll.mui"; DestDir: "{app}\ar-sa"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\ar-sa'))
Source: "{#WinHelpResSrcPrefix64}ar-sa_2f09ffba55ebaab5\winhlp32.exe.mui"; DestDir: "{app}\ar-sa"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\ar-sa'))
Source: "{#WinHelpResSrcPrefix64}cs-cz_805357de33f3d837\*.dll.mui"; DestDir: "{app}\cs-cz"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\cs-cz'))
Source: "{#WinHelpResSrcPrefix64}cs-cz_805357de33f3d837\winhlp32.exe.mui"; DestDir: "{app}\cs-cz"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\cs-cz'))
Source: "{#WinHelpResSrcPrefix64}da-dk_1d8d38052a39d436\*.dll.mui"; DestDir: "{app}\da-dk"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\da-dk'))
Source: "{#WinHelpResSrcPrefix64}da-dk_1d8d38052a39d436\winhlp32.exe.mui"; DestDir: "{app}\da-dk"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\da-dk'))
Source: "{#WinHelpResSrcPrefix64}de-de_1ab8cd412c1028d0\*.dll.mui"; DestDir: "{app}\de-de"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\da-dk'))
Source: "{#WinHelpResSrcPrefix64}de-de_1ab8cd412c1028d0\winhlp32.exe.mui"; DestDir: "{app}\de-de"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\de-de'))
Source: "{#WinHelpResSrcPrefix64}el-gr_c34efad41b25915e\*.dll.mui"; DestDir: "{app}\el-gr"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\el-gr'))
Source: "{#WinHelpResSrcPrefix64}el-gr_c34efad41b25915e\winhlp32.exe.mui"; DestDir: "{app}\el-gr"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\el-gr'))
Source: "{#WinHelpResSrcPrefix64}en-us_c3a9a33a1aee3495\*.dll.mui"; DestDir: "{app}\en-us"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\en-us'))
Source: "{#WinHelpResSrcPrefix64}en-us_c3a9a33a1aee3495\winhlp32.exe.mui"; DestDir: "{app}\en-us"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\en-us'))
Source: "{#WinHelpResSrcPrefix64}es-es_c375001e1b15263a\*.dll.mui"; DestDir: "{app}\es-es"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\es-es'))
Source: "{#WinHelpResSrcPrefix64}es-es_c375001e1b15263a\winhlp32.exe.mui"; DestDir: "{app}\es-es"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\es-es'))
Source: "{#WinHelpResSrcPrefix64}fi-fi_629004cb102f1864\*.dll.mui"; DestDir: "{app}\fi-fi"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\fi-fi'))
Source: "{#WinHelpResSrcPrefix64}fi-fi_629004cb102f1864\winhlp32.exe.mui"; DestDir: "{app}\fi-fi"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\fi-fi'))
Source: "{#WinHelpResSrcPrefix64}fr-fr_662c761d0de73c9c\*.dll.mui"; DestDir: "{app}\fr-fr"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\fr-fr'))
Source: "{#WinHelpResSrcPrefix64}fr-fr_662c761d0de73c9c\winhlp32.exe.mui"; DestDir: "{app}\fr-fr"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\fr-fr'))
Source: "{#WinHelpResSrcPrefix64}he-il_aa4c1dbef4563d8a\*.dll.mui"; DestDir: "{app}\he-il"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\he-il'))
Source: "{#WinHelpResSrcPrefix64}he-il_aa4c1dbef4563d8a\winhlp32.exe.mui"; DestDir: "{app}\he-il"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\he-il'))
Source: "{#WinHelpResSrcPrefix64}hu-hu_ad9cf664f2470bb8\*.dll.mui"; DestDir: "{app}\hu-hu"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\hu-hu'))
Source: "{#WinHelpResSrcPrefix64}hu-hu_ad9cf664f2470bb8\winhlp32.exe.mui"; DestDir: "{app}\hu-hu"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\hu-hu'))
Source: "{#WinHelpResSrcPrefix64}it-it_50546c63e519221a\*.dll.mui"; DestDir: "{app}\it-it"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\it-it'))
Source: "{#WinHelpResSrcPrefix64}it-it_50546c63e519221a\winhlp32.exe.mui"; DestDir: "{app}\it-it"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\it-it'))
Source: "{#WinHelpResSrcPrefix64}ja-jp_f279eb70d83433f5\*.dll.mui"; DestDir: "{app}\ja-jp"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\ja-jp'))
Source: "{#WinHelpResSrcPrefix64}ja-jp_f279eb70d83433f5\winhlp32.exe.mui"; DestDir: "{app}\ja-jp"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\ja-jp'))
Source: "{#WinHelpResSrcPrefix64}ko-kr_95e3c825caa4fb0b\*.dll.mui"; DestDir: "{app}\ko-kr"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\ko-kr'))
Source: "{#WinHelpResSrcPrefix64}ko-kr_95e3c825caa4fb0b\winhlp32.exe.mui"; DestDir: "{app}\ko-kr"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\ko-kr'))
Source: "{#WinHelpResSrcPrefix64}nb-no_7e76495aa2ca26c7\*.dll.mui"; DestDir: "{app}\nb-no"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\nb-no'))
Source: "{#WinHelpResSrcPrefix64}nb-no_7e76495aa2ca26c7\winhlp32.exe.mui"; DestDir: "{app}\nb-no"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\nb-no'))
Source: "{#WinHelpResSrcPrefix64}nl-nl_7cb59498a3f6309c\*.dll.mui"; DestDir: "{app}\nl-nl"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\nl-nl'))
Source: "{#WinHelpResSrcPrefix64}nl-nl_7cb59498a3f6309c\winhlp32.exe.mui"; DestDir: "{app}\nl-nl"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\nl-nl'))
Source: "{#WinHelpResSrcPrefix64}pl-pl_c2f1ef1a89189e50\*.dll.mui"; DestDir: "{app}\pl-pl"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\pl-pl'))
Source: "{#WinHelpResSrcPrefix64}pl-pl_c2f1ef1a89189e50\winhlp32.exe.mui"; DestDir: "{app}\pl-pl"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\pl-pl'))
Source: "{#WinHelpResSrcPrefix64}pt-br_c545d9be87a23234\*.dll.mui"; DestDir: "{app}\pt-br"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\pt-br'))
Source: "{#WinHelpResSrcPrefix64}pt-br_c545d9be87a23234\winhlp32.exe.mui"; DestDir: "{app}\pt-br"; DestName: "mywinhlp.exe.mui"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\pt-br'))
Source: "{#WinHelpResSrcPrefix64}pt-pt_c627a92a8711a210\*.dll.mui"; DestDir: "{app}\pt-pt"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\pt-pt'))
Source: "{#WinHelpResSrcPrefix64}pt-pt_c627a92a8711a210\winhlp32.exe.mui"; DestDir: "{app}\pt-pt"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\pt-pt'))
Source: "{#WinHelpResSrcPrefix64}ru-ru_0ccabaee6bf3303c\*.dll.mui"; DestDir: "{app}\ru-ru"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\ru-ru'))
Source: "{#WinHelpResSrcPrefix64}ru-ru_0ccabaee6bf3303c\winhlp32.exe.mui"; DestDir: "{app}\ru-ru"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\ru-ru'))
Source: "{#WinHelpResSrcPrefix64}sv-se_a8c5a563631c3a97\*.dll.mui"; DestDir: "{app}\sv-se"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\sv-se'))
Source: "{#WinHelpResSrcPrefix64}sv-se_a8c5a563631c3a97\winhlp32.exe.mui"; DestDir: "{app}\sv-se"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\sv-se'))
Source: "{#WinHelpResSrcPrefix64}tr-tr_51d2efaa51d83c88\*.dll.mui"; DestDir: "{app}\tr-tr"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\tr-tr'))
Source: "{#WinHelpResSrcPrefix64}tr-tr_51d2efaa51d83c88\winhlp32.exe.mui"; DestDir: "{app}\tr-tr"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\tr-tr'))
Source: "{#WinHelpResSrcPrefix64}zh-cn_23300da802100ea7\*.dll.mui"; DestDir: "{app}\zh-cn"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\zh-cn'))
Source: "{#WinHelpResSrcPrefix64}zh-cn_23300da802100ea7\winhlp32.exe.mui"; DestDir: "{app}\zh-cn"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\zh-cn'))
Source: "{#WinHelpResSrcPrefix64}zh-tw_272c4afdff80eb17\*.dll.mui"; DestDir: "{app}\zh-tw"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\zh-tw'))
Source: "{#WinHelpResSrcPrefix64}zh-tw_272c4afdff80eb17\winhlp32.exe.mui"; DestDir: "{app}\zh-tw"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: IsWin64 and DirExists(ExpandConstant('{win}\zh-tw'))
// 32 Bit WinHelp files
Source: "{#WinHelpSrcPrefix32}\x86_microsoft-windows-winhstb_31bf3856ad364e35_6.3.9600.20470_none_be363e6f3e19858c\*.dll"; DestDir: "{app}"; Flags: ignoreversion external; Check: not IsWin64
Source: "{#WinHelpSrcPrefix32}\x86_microsoft-windows-winhstb_31bf3856ad364e35_6.3.9600.20470_none_be363e6f3e19858c\winhlp32.exe"; DestDir: "{app}"; DestName: "mywinhlp32.exe"; Flags: ignoreversion external; Check: not IsWin64
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_ar-sa_d2eb64369d8e397f\*.dll.mui"; DestDir: "{app}\ar-sa"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\ar-sa'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_ar-sa_d2eb64369d8e397f\winhlp32.exe.mui"; DestDir: "{app}\ar-sa"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\ar-sa'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_cs-cz_2434bc5a7b966701\*.dll.mui"; DestDir: "{app}\cs-cz"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\cs-cz'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_cs-cz_2434bc5a7b966701\winhlp32.exe.mui"; DestDir: "{app}\cs-cz"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\cs-cz'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_da-dk_c16e9c8171dc6300\*.dll.mui"; DestDir: "{app}\da-dk"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\da-dk'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_da-dk_c16e9c8171dc6300\winhlp32.exe.mui"; DestDir: "{app}\da-dk"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\da-dk'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_de-de_be9a31bd73b2b79a\*.dll.mui"; DestDir: "{app}\de-de"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\de-de'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_de-de_be9a31bd73b2b79a\winhlp32.exe.mui"; DestDir: "{app}\de-de"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\de-de'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_el-gr_67305f5062c82028\*.dll.mui"; DestDir: "{app}\el-gr"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\el-gr'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_el-gr_67305f5062c82028\winhlp32.exe.mui"; DestDir: "{app}\el-gr"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\el-gr'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_en-us_678b07b66290c35f\*.dll.mui"; DestDir: "{app}\en-us"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\en-us'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_en-us_678b07b66290c35f\winhlp32.exe.mui"; DestDir: "{app}\en-us"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\en-us'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_es-es_6756649a62b7b504\*.dll.mui"; DestDir: "{app}\es-es"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\es-es'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_es-es_6756649a62b7b504\winhlp32.exe.mui"; DestDir: "{app}\es-es"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\es-es'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_fi-fi_0671694757d1a72e\*.dll.mui"; DestDir: "{app}\fi-fi"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\fi-fi'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_fi-fi_0671694757d1a72e\winhlp32.exe.mui"; DestDir: "{app}\fi-fi"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\fi-fi'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_fr-fr_0a0dda995589cb66\*.dll.mui"; DestDir: "{app}\fr-fr"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\fr-fr'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_fr-fr_0a0dda995589cb66\winhlp32.exe.mui"; DestDir: "{app}\fr-fr"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\fr-fr'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_he-il_4e2d823b3bf8cc54\*.dll.mui"; DestDir: "{app}\he-il"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\he-il'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_he-il_4e2d823b3bf8cc54\winhlp32.exe.mui"; DestDir: "{app}\he-il"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\he-il'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_hu-hu_517e5ae139e99a82\*.dll.mui"; DestDir: "{app}\hu-hu"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\hu-hu'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_hu-hu_517e5ae139e99a82\winhlp32.exe.mui"; DestDir: "{app}\hu-hu"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\hu-hu'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_it-it_f435d0e02cbbb0e4\*.dll.mui"; DestDir: "{app}\it-it"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\it-it'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_it-it_f435d0e02cbbb0e4\winhlp32.exe.mui"; DestDir: "{app}\it-it"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\it-it'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_ja-jp_965b4fed1fd6c2bf\*.dll.mui"; DestDir: "{app}\ja-jp"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\ja-jp'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_ja-jp_965b4fed1fd6c2bf\winhlp32.exe.mui"; DestDir: "{app}\ja-jp"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\ja-jp'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_ko-kr_39c52ca2124789d5\*.dll.mui"; DestDir: "{app}\ko-kr"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\ko-kr'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_ko-kr_39c52ca2124789d5\winhlp32.exe.mui"; DestDir: "{app}\ko-kr"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\ko-kr'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_nb-no_2257add6ea6cb591\*.dll.mui"; DestDir: "{app}\nb-no"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\nb-no'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_nb-no_2257add6ea6cb591\winhlp32.exe.mui"; DestDir: "{app}\nb-no"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\nb-no'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_nl-nl_2096f914eb98bf66\*.dll.mui"; DestDir: "{app}\nl-nl"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\nl-nl'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_nl-nl_2096f914eb98bf66\winhlp32.exe.mui"; DestDir: "{app}\nl-nl"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\nl-nl'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_pl-pl_66d35396d0bb2d1a\*.dll.mui"; DestDir: "{app}\pl-pl"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\pl-pl'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_pl-pl_66d35396d0bb2d1a\winhlp32.exe.mui"; DestDir: "{app}\pl-pl"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\pl-pl'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_pt-br_69273e3acf44c0fe\*.dll.mui"; DestDir: "{app}\pt-br"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\pt-br'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_pt-br_69273e3acf44c0fe\winhlp32.exe.mui"; DestDir: "{app}\pt-br"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\pt-br'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_pt-pt_6a090da6ceb430da\*.dll.mui"; DestDir: "{app}\pt-pt"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\pt-pt'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_pt-pt_6a090da6ceb430da\winhlp32.exe.mui"; DestDir: "{app}\pt-pt"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\pt-pt'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_ru-ru_b0ac1f6ab395bf06\*.dll.mui"; DestDir: "{app}\ru-ru"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\ru-ru'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_ru-ru_b0ac1f6ab395bf06\winhlp32.exe.mui"; DestDir: "{app}\ru-ru"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\ru-ru'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_sv-se_4ca709dfaabec961\*.dll.mui"; DestDir: "{app}\sv-se"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\sv-se'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_sv-se_4ca709dfaabec961\winhlp32.exe.mui"; DestDir: "{app}\sv-se"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\sv-se'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_tr-tr_f5b45426997acb52\*.dll.mui"; DestDir: "{app}\tr-tr"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\tr-tr'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_tr-tr_f5b45426997acb52\winhlp32.exe.mui"; DestDir: "{app}\tr-tr"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\tr-tr'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_zh-cn_c711722449b29d71\*.dll.mui"; DestDir: "{app}\zh-cn"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\zh-cn'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_zh-cn_c711722449b29d71\winhlp32.exe.mui"; DestDir: "{app}\zh-cn"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\zh-cn'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_zh-tw_cb0daf7a472379e1\*.dll.mui"; DestDir: "{app}\zh-tw"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\zh-tw'))
Source: "{#WinHelpResSrcPrefix32}\x86_microsoft-windows-winhstb.resources_31bf3856ad364e35_6.3.9600.20470_zh-tw_cb0daf7a472379e1\winhlp32.exe.mui"; DestDir: "{app}\zh-tw"; DestName: "mywinhlp32.exe.mui"; Flags: ignoreversion external; Check: not IsWin64 and DirExists(ExpandConstant('{win}\zh-tw'))


[Registry]
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\winhlp32.exe"; ValueType: string; ValueName: "Debugger"; ValueData: """{app}\WinHelpProxy.exe"""; Flags: uninsdeletevalue uninsdeletekeyifempty


[Code]
var
  DownloadPage: TDownloadWizardPage;
  MsuPath: String;


// Download WinHelp Windows update
function DownloadWinHelpUpdate: Boolean;
var
  Msg: String;
begin
  Result := False;
  DownloadPage.Clear;
  DownloadPage.Add('{#MsuDownloadUrl}', '{#MsuFileName}', '');
  DownloadPage.Show;
  try
    try
      DownloadPage.Download;
      MsuPath := ExpandConstant('{tmp}\{#MsuFileName}');
      Result := True;
    except
      Msg := 'Error downloading {#MsuDownloadUrl}: ' + GetExceptionMessage; 
      Log(Msg);
      SuppressibleMsgBox(Msg, mbCriticalError, MB_OK, IDOK);
    end;
  finally
    DownloadPage.Hide;
  end;
end;


// Extract WinHelp files from MSU file
function ExtractWinHelpFromMsu: Boolean;
var
  BatPath: String;
  TmpPath: String;
  Params: String;
  ResultCode: Integer;
  ShowCmd: Integer;
  DoPauseScript: Boolean;
  Msg: String;
begin
  Result := True;

  // Extract script file from setup
  ExtractTemporaryFile('ExtractWinHelpFiles.cmd');

  // Prepare paths
  BatPath := ExpandConstant('{tmp}\ExtractWinHelpFiles.cmd');
  TmpPath := ExpandConstant('{#WinHelpSrcDir}');
  Params := '"' + MsuPath + '"  "' + TmpPath + '"';

  // Determine show mode and pause
  DoPauseScript := False;
  ShowCmd := SW_HIDE;

  // Check for debug switch
  if ExpandConstant('{param:DebugBat}') = '1' then
  begin
    DoPauseScript := True;
    ShowCmd := SW_SHOW;
  end;

  // Add parameter to indicate pausing script
  if DoPauseScript then
  begin
    Params := Params + ' 1';
  end
  else
  begin
    Params := Params + ' 0';
  end;

  // Launch script and eval result
  Log(Format('Launching %s with params %s', [BatPath, Params]));
  if not Exec(BatPath, Params, '', ShowCmd, ewWaitUntilTerminated, ResultCode) then
  begin
    Msg := Format('Failed to extract WinHelp files from %s', [MsuPath]);
    Log(Msg);
    SuppressibleMsgBox(Msg, mbCriticalError, MB_OK, IDOK);
    Result := False;
  end;
  Log(Format('Result code: %d', [ResultCode]));
  if ResultCode <> 0 then
  begin
    Msg := Format('Failed to extract WinHelp files from %s', [MsuPath]);
    Log(Msg);
    SuppressibleMsgBox(Msg, mbCriticalError, MB_OK, IDOK);
    Result := False;
  end;
end;


// Track download progress
function OnDownloadProgress(const Url, FileName: String; const Progress, ProgressMax: Int64): Boolean;
begin
  if Progress = ProgressMax then
  begin
    Log(Format(ExpandConstant('Successfully downloaded file to {tmp}: %s'), [FileName]));
  end;
  Result := True;
end;


// Initialize wizard
procedure InitializeWizard;
var
  TmpPath: String;
begin
  // Check if MSU file is available
  TmpPath := ExpandConstant('{src}\{#MsuFileName}');
  if FileExists(TmpPath) then
  begin
    Log('Use existing MSU file: ' + TmpPath);
    MsuPath := TmpPath;
  end
  else
  begin
    Log('No MSU file found => must be downloaded');
    DownloadPage := CreateDownloadPage(SetupMessage(msgWizardPreparing), SetupMessage(msgPreparingDesc), @OnDownloadProgress);
    MsuPath := '';
  end;
end;


// When wizard page changes
procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID = wpReady then
  begin
    WizardForm.NextButton.Caption := SetupMessage(msgButtonInstall)
  end;
end;



// When preparing to install
function PrepareToInstall(var NeedsRestart: Boolean): String;
begin
  if not ExtractWinHelpFromMsu then
  begin
    Result := 'Error extracting WinHelp files from ' + MsuPath;
  end;
end;



// When clicking "Next" button
function NextButtonClick(CurPageID: Integer): Boolean;
begin
  if CurPageID = wpReady then 
  begin
    // Download MSU file if required
    if MsuPath = '' then
    begin
      Result := DownloadWinHelpUpdate;
    end
    else
    begin
      Result := True;
    end;
  end 
  else
  begin
    Result := True;
  end;
end;



