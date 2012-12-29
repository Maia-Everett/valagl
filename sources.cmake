set(STEADYFLOW_CORE_CLASSES
	DownloadService
	GioDownloadFile
	GioSettingsService
	IDownloadFile
	IDownloadService
	ISettingsService
	OptionParser
	Util
)

set(STEADYFLOW_UI_CLASSES
	DownloadCellRenderer
	GtkBuilderDialog
	GtkBuilderWindow
	IGtkBuilderContainer
	IIndicatorService
	UIUtil
)

if(HAVE_AYATANA)
	set(STEADYFLOW_UI_CLASSES ${STEADYFLOW_UI_CLASSES} AyatanaIndicatorService)
else(HAVE_AYATANA)
	set(STEADYFLOW_UI_CLASSES ${STEADYFLOW_UI_CLASSES} TrayIndicatorService)
endif(HAVE_AYATANA)

set(STEADYFLOW_CLASSES
	AddFileDialog
	Application
	AppService
	FileListController
	IAppService
	IndicatorController
	MainWindow
	NotificationController
	PreferencesDialog
	Services
)

foreach(CLASS ${STEADYFLOW_CORE_CLASSES})
	set(STEADYFLOW_SOURCES ${STEADYFLOW_SOURCES} "Steadyflow.Core/${CLASS}.vala")
endforeach()

foreach(CLASS ${STEADYFLOW_UI_CLASSES})
	set(STEADYFLOW_SOURCES ${STEADYFLOW_SOURCES} "Steadyflow.UI/${CLASS}.vala")
endforeach()

foreach(CLASS ${STEADYFLOW_CLASSES})
	set(STEADYFLOW_SOURCES ${STEADYFLOW_SOURCES} "Steadyflow/${CLASS}.vala")
endforeach()
