################################################################
#### 
#### Author: Dongxu Ma <dongxu.ma@gmail.com>
#### License: Artistic
#### 
################################################################

# QT4 META CONFIGURATION
# this line will be scaned by script/gen_makefile_pl.pl
# no make variables inside, keep value in one line
_HEADER_DIR := /usr/include/qt4

#_QT         := QtCore QtGui QtOpenGL QtSvg QtNetwork QtSql QtXml \
#               Qt3Support 
_QT := QtOpenGL

#_QT_EXTRA := QtAssistant QtDBus QtUiTools QtDesigner QtTest

_HEADERS  := $(addprefix $(_HEADER_DIR)/$(_QT)/, $(shell script/grep_headers.sh $(_HEADER_DIR)/$(_QT)/$(_QT)))
# common enums declared in qnamespace.h
_HEADERS  += $(_HEADER_DIR)/QtCore/qnamespace.h $(_HEADER_DIR)/QtCore/qglobal.h $(_HEADER_DIR)/QtGui/qgenericmatrix.h

HEADER_PREFIX := h

# imacros list
# which will be passed to preprocessor
_IMACROS := QtCore/qglobal.h QtCore/qconfig.h QtCore/qfeatures.h

# core define modules
# this line will be scaned by script/gen_makefile_pl.pl
# no make variables inside, keep value in one line
OPENGL_DEFINES  := -DQT_OPENGL_LIB -DQT_SHARED -DQT_NO_DEBUG

# NOTE: keep the default visibility mark as 'Q_DECL_EXPORT'
#       or else normally it will be expanded to
#       '__attribute__((visibility("default")))' on Linux
#       '__declspec(dllexport)'                  on Windows
#       parser will benefit on such uniform look
# -DQT_VISIBILITY_AVAILABLE
EXTRA_DEFINES := -DQT_NO_KEYWORDS -DQ_DECL_EXPORT="Q_DECL_EXPORT" -DQ_OPENGL_EXPORT="Q_DECL_EXPORT"

ALL_DEFINES   := $(OPENGL_DEFINES) $(EXTRA_DEFINES)

# gcc
# only available on x86_64
_CMD_CC := g++

override MAKE_ROOT = .

# pkg-config --cflags --libs QtCore
# following is not used by GNUmakefile
# each line will be scaned by script/gen_makefile_pl.pl
# no make variables inside, keep value in one line
LDFLAGS := -L/usr/lib/qt4 -lQtOpenGL -lQtGui -lQtCore
