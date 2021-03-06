################################################################
####
#### Author: Dongxu Ma <dongxu.ma@gmail.com>
#### License: Artistic
####
################################################################

#################### META CONFIG ###############################
CONFIG_DOT_MK   := config.mk
include $(CONFIG_DOT_MK)

#################### SHELL    ##################################
SHELL=/bin/bash

#################### DIRECTORY STRUCTURES ######################

# FIXME: oops on MSWin32, unknown on Darwin
# always try to be absolute

MAKE_ROOT       := $(shell pwd)
HEADER_DIR      := $(_HEADER_DIR)
# NOTE: ugly hack to permit custom PERL5LIB
SCRIPT_DIR      := $(_PERL5) $(MAKE_ROOT)/script
TEMPLATE_DIR    := $(MAKE_ROOT)/template

IN_STRIP_DIR    := $(HEADER_DIR)
OUT_STRIP_DIR   := $(MAKE_ROOT)/00strip

IN_PREPRO_DIR   := $(OUT_STRIP_DIR)
OUT_PREPRO_DIR  := $(MAKE_ROOT)/01prepro

IN_PARSE_DIR    := $(OUT_PREPRO_DIR)
OUT_PARSE_DIR   := $(MAKE_ROOT)/02parse

IN_FORMAT_DIR   := $(OUT_PARSE_DIR)
OUT_FORMAT_DIR  := $(MAKE_ROOT)/03format

IN_GROUP_DIR    := $(OUT_FORMAT_DIR)
OUT_GROUP_DIR   := $(MAKE_ROOT)/04group

IN_TYPEMAP_DIR  := $(OUT_GROUP_DIR)
OUT_TYPEMAP_DIR := $(MAKE_ROOT)/05typemap

OUT_TEMPLATE_DIR:= $(MAKE_ROOT)/06template

IN_XSCODE_DIR   := $(OUT_GROUP_DIR)
OUT_XSCODE_DIR  := $(MAKE_ROOT)/99xscode
OUT_PMCODE_DIR  := $(MAKE_ROOT)/99pmcode

TEST_DIR        := $(MAKE_ROOT)/t

#################### MAKE TOOLS ################################

# DEBUG echos all shell commands
ifndef DEBUG
_Q := @
else
_Q := $(empty)$(empty)
endif

# FIXME: check available options for all involved commands
CMD_CC             := $(_CMD_CC)
CMD_CC             ?= g++
# intepretable echo
CMD_ECHO           := echo -e
CMD_PREPRO         := $(CMD_CC) -E -P
CMD_PARSE          := $(SCRIPT_DIR)/parse_header.pl
CMD_MKDIR          := mkdir -p
CMD_MV             := mv -f
CMD_CAT            := cat
CMD_RM             := rm -f
CMD_RMDIR          := rm -rf
CMD_SYMLINK        := ln -sf
CMD_PERL           := perl
CMD_CPDIR          := cp -apr

OPT_CC_INPUT       := $(empty)$(empty)
OPT_CC_OUTPUT      := -o
IMACROS            := $(_IMACROS)

CMD_HEADER_LIST    := $(SCRIPT_DIR)/grep_headers.sh
CMD_STRIP_INC      := $(SCRIPT_DIR)/strip_include.pl
CMD_STRIP_MK       := $(SCRIPT_DIR)/gen_strip_mk.pl
CMD_PREPRO_HD      := $(CMD_PREPRO) $(ALL_DEFINES) $(CXXFLAGS)\
                          -I$(HEADER_DIR)
CMD_PREPRO_MK      := $(SCRIPT_DIR)/gen_prepro_mk.pl
CMD_PARSE_HD       := $(CMD_PARSE)
CMD_PARSE_MK       := $(SCRIPT_DIR)/gen_parse_mk.pl
CMD_FORMAT_YML     := $(SCRIPT_DIR)/format_qtedi_production.pl
CMD_FORMAT_MK      := $(SCRIPT_DIR)/gen_format_mk.pl
CMD_GROUP_MK       := $(SCRIPT_DIR)/gen_group_mk.pl
CMD_GROUP_YML      := $(SCRIPT_DIR)/group_by_namespace.pl
CMD_GROUP_CHECK    := $(SCRIPT_DIR)/check_class_consistency.sh
CMD_GROUPLIST_MK   := $(SCRIPT_DIR)/gen_grouplist_mk.pl
CMD_XSCODE_MK      := $(SCRIPT_DIR)/gen_xscode_mk.pl
CMD_CREAT_TP       := $(SCRIPT_DIR)/create_typemap.pl
CMD_TYPEMAPLIST_MK := $(SCRIPT_DIR)/gen_typemaplist_mk.pl
CMD_TYPEMAP        := $(SCRIPT_DIR)/finalize_typemap.pl
CMD_PKGMAP         := $(SCRIPT_DIR)/create_packagemap.pl
CMD_PKGMAP_TEMPLATE:= $(SCRIPT_DIR)/group_by_template.pl
CMD_CREAT_XS       := $(SCRIPT_DIR)/create_xs_code.pl
CMD_TYPEMAP_XS     := $(SCRIPT_DIR)/create_xs_typemap.pl
CMD_CREAT_PM       := $(SCRIPT_DIR)/create_pm_code.pl
CMD_YGREP          := $(SCRIPT_DIR)/util_ygrep.pl
CMD_GET_CONF       := $(SCRIPT_DIR)/get_module_conf_value.pl
CMD_ROOT_XS        := $(SCRIPT_DIR)/create_top_dot_xs.pl
CMD_ENUMMAP        := $(SCRIPT_DIR)/create_enummap.pl
CMD_MAKEFILE_PL    := $(SCRIPT_DIR)/gen_makefile_pl.pl
CMD_00USE_T        := $(SCRIPT_DIR)/gen_00use_t.pl
CMD_MANIFEST       := $(SCRIPT_DIR)/gen_manifest.pl

MODULE_DOT_CONF    := $(MAKE_ROOT)/module.conf
HEADER_DOT_MK      := $(MAKE_ROOT)/header.mk
STRIP_DOT_MK       := $(MAKE_ROOT)/strip.mk
PREPRO_DOT_MK      := $(MAKE_ROOT)/preprocess.mk
PARSE_DOT_MK       := $(MAKE_ROOT)/parse.mk
FORMAT_DOT_MK      := $(MAKE_ROOT)/format.mk
GROUP_DOT_MK       := $(MAKE_ROOT)/group.mk
GROUPLIST_DOT_MK   := $(MAKE_ROOT)/grouplist.mk
TYPEMAPLIST_DOT_MK := $(MAKE_ROOT)/typemaplist.mk
XSCODE_DOT_MK      := $(MAKE_ROOT)/xscode.mk
BUILD_DOT_MK       := $(MAKE_ROOT)/build.mk

# temp use
TYPEMAP_DOT_DEP    := $(OUT_GROUP_DIR)/.typemap.dep
TYPEMAP2_DOT_DEP   := $(OUT_TEMPLATE_DIR)/.typemap.dep
# used by script/create_typemap.pl
TYPEMAP_DOT_IGNORE := $(MAKE_ROOT)/typemap.ignore
TYPEMAP_DOT_SIMPLE := $(MAKE_ROOT)/typemap.simple
TYPEMAP_DOT_MANUAL := $(MAKE_ROOT)/typemap.manual
TYPEMAP_DOT_TT2    := $(TEMPLATE_DIR)/typemap.tt2
TYPEMAP2_DOT_TT2   := $(TEMPLATE_DIR)/typemap2.tt2

#################### TARGETS ###################################

HEADERS         := $(_HEADERS)
HEADERS_NO_ROOT := $(patsubst $(HEADER_DIR)/%,%,$(HEADERS))

STRIP_HEADERS   := $(addprefix $(OUT_STRIP_DIR)/,$(HEADERS_NO_ROOT))
PREPRO_HEADERS  := $(addprefix $(OUT_PREPRO_DIR)/,\
                       $(patsubst %.$(HEADER_PREFIX),%.i,$(HEADERS_NO_ROOT)))
PARSE_HEADERS   := $(addprefix $(OUT_PARSE_DIR)/,\
                       $(patsubst %.$(HEADER_PREFIX),%.yml,$(HEADERS_NO_ROOT)))
FORMAT_YAMLS    := $(addprefix $(OUT_FORMAT_DIR)/,\
                       $(patsubst %.$(HEADER_PREFIX),%.yml,$(HEADERS_NO_ROOT)))
# initially empty, overriden inside grouplist.mk
GROUP_YAMLS     := $(empty)$(empty)
# initially empty, overriden inside xscode.mk
TYPEMAP_YAMLS   := $(empty)$(empty)
TYPEMAP_DRAFT   := $(OUT_TYPEMAP_DIR)/typemap_draft
TYPEMAP_TEMPLATE_DRAFT := $(OUT_TYPEMAP_DIR)/typemap_template_draft
TYPEMAP         := $(OUT_TYPEMAP_DIR)/typemap
TYPEMAP_TEMPLATE:= $(OUT_TYPEMAP_DIR)/typemap_template
PACKAGEMAP      := $(OUT_TYPEMAP_DIR)/packagemap
TYPEMAP2_DRAFT  := $(OUT_TEMPLATE_DIR)/typemap_draft
TYPEMAP2        := $(OUT_TEMPLATE_DIR)/typemap
TYPEMAP2_TEMPLATE_DRAFT:= $(OUT_TEMPLATE_DIR)/typemap_template_draft
PACKAGEMAP2     := $(OUT_TEMPLATE_DIR)/packagemap
ENUMMAP         := $(OUT_TYPEMAP_DIR)/enummap
TYPEMAP_XS      := $(MAKE_ROOT)/typemap
_ROOT_FILENAME  := $(shell $(CMD_GET_CONF) -conf $(MODULE_DOT_CONF) \
                       -f 'root_filename')
ROOT_XS         := $(MAKE_ROOT)/$(_ROOT_FILENAME).xs
ROOT_C          := $(MAKE_ROOT)/$(_ROOT_FILENAME).c
DEFAULT_TYPEDEF := $(OUT_GROUP_DIR)/$(subst ::,__,$(shell $(CMD_GET_CONF) \
                       -conf $(MODULE_DOT_CONF) -f 'default_namespace')).typedef
MAKEFILE_PL     := $(MAKE_ROOT)/Makefile.PL
00USE_T         := $(TEST_DIR)/00use.t
MANIFEST        := $(MAKE_ROOT)/MANIFEST
MAKEFILE_PERL   := $(MAKE_ROOT)/Makefile
TEMPLATE_DOT_PM := $(OUT_PMCODE_DIR)/$(subst ::,/,$(shell $(CMD_GET_CONF) \
                       -conf $(MODULE_DOT_CONF) -f 'default_namespace'))/Template.pm

#################### SUBROUTINES ###############################

_remove_file = echo removing $1; \
               if [[ -f $1 ]] ; then $(CMD_RM) $1 ; fi
_remove_dir  = echo removing $1; \
               if [[ -d $1 ]] ; then $(CMD_RMDIR) $1 ; fi
# generate imacros options for g++ preprocessor
# exclude process target file from imacros files
# this mainly works for QtCore/qglobal.h in QT
_generate_imacros = $(addprefix -imacros ,$(addprefix             \
                        $(HEADER_DIR)/,$(filter-out               \
                            %/$(notdir $1),$(IMACROS))))

#################### PHONY and FRIENDS #########################

# default goal
all:
.PHONY: all

.SUFFIXES: .$(HEADER_PREFIX) .i .yml .meta                        \
           .function .public .protected .signal .typedef .enum

FORCE: ;

ifneq ($(MAKECMDGOALS),)
_GOALS := $(MAKECMDGOALS)
else
_GOALS := all
endif

#################### META RULES and PATTERNS ###################

# FIXME: great performance issue
$(HEADER_DOT_MK): $(HEADERS)
	$(_Q)echo generating $@
	$(shell echo > $@)
	$(foreach i,$(HEADERS),$(shell $(CMD_ECHO) "$i: \n" >> $@))

# strip include directives
# or preprocessor will croak
$(STRIP_DOT_MK): $(HEADER_DOT_MK)
	$(_Q)echo generating $@
	$(_Q)[[ -d $(OUT_STRIP_DIR) ]] || $(CMD_MKDIR) $(OUT_STRIP_DIR)
	$(_Q)$(CMD_STRIP_MK) $< $(IN_STRIP_DIR) $(OUT_STRIP_DIR) $@

# preprocess to omit macros
$(PREPRO_DOT_MK): $(HEADER_DOT_MK)
	$(_Q)echo generating $@
	$(_Q)[[ -d $(OUT_PREPRO_DIR) ]] || $(CMD_MKDIR) $(OUT_PREPRO_DIR)
	$(_Q)$(CMD_PREPRO_MK) $< $(IN_STRIP_DIR) $(IN_PREPRO_DIR) \
        $(OUT_PREPRO_DIR) $@

# parse preprocessed headers
# YAML output
$(PARSE_DOT_MK): $(HEADER_DOT_MK)
	$(_Q)echo generating $@
	$(_Q)[[ -d $(OUT_PARSE_DIR) ]] || $(CMD_MKDIR) $(OUT_PARSE_DIR)
	$(_Q)$(CMD_PARSE_MK) $< $(IN_STRIP_DIR) $(IN_PARSE_DIR) \
        $(OUT_PARSE_DIR) $@

# strip && format parse productions
# YAML output
$(FORMAT_DOT_MK): $(HEADER_DOT_MK)
	$(_Q)echo generating $@
	$(_Q)[[ -d $(OUT_FORMAT_DIR) ]] || $(CMD_MKDIR) $(OUT_FORMAT_DIR)
	$(_Q)$(CMD_FORMAT_MK) $< $(IN_STRIP_DIR) $(IN_FORMAT_DIR) \
        $(OUT_FORMAT_DIR) $@

# group formatted yaml
$(GROUP_DOT_MK): $(HEADER_DOT_MK) $(MODULE_DOT_CONF)
	$(_Q)echo generating $@
	$(_Q)$(CMD_GROUP_MK) $< $(IN_STRIP_DIR) $(IN_GROUP_DIR) \
        $(OUT_GROUP_DIR) $(MODULE_DOT_CONF) $@

$(GROUPLIST_DOT_MK): $(GROUP_DOT_MK)

$(XSCODE_DOT_MK)   : $(GROUP_DOT_MK) $(GROUPLIST_DOT_MK)     \
                     $(TYPEMAPLIST_DOT_MK) $(GROUP_YAMLS)    \
                     $(TYPEMAP) $(PACKAGEMAP) $(TYPEMAP2) $(PACKAGEMAP2)
	$(_Q)echo generating $@
	$(_Q)$(CMD_XSCODE_MK) -conf $(MODULE_DOT_CONF)             \
        $(IN_XSCODE_DIR) $(OUT_TEMPLATE_DIR) $(OUT_XSCODE_DIR) \
        $(OUT_PMCODE_DIR) $(OUT_TYPEMAP_DIR) $@

# generate xs && pm code
# GROUP_YAMLS from grouplist.mk
# in case grouplist.mk doesn't exist
# shell will complain, eval will have nothing to bless
# grouplist.mk be rebuilt finally
# priority:
# group.mk > grouplist.mk > files under OUT_GROUP_DIR
# on the other hand, grouplist.mk behaves like a
# checksum of staff under OUT_GROUP_DIR
# removal of any file which was produced by latest
# gen_group triggers rebuild of all so-called
# 'standard' files
# $(GROUPLIST_DOT_MK) defined in $(GROUP_DOT_MK)
ifeq ($(filter clean%,$(_GOALS)),)
$(info including $(HEADER_DOT_MK))
include $(HEADER_DOT_MK)
$(info including $(STRIP_DOT_MK))
include $(STRIP_DOT_MK)
$(info including $(PREPRO_DOT_MK))
include $(PREPRO_DOT_MK)
$(info including $(PARSE_DOT_MK))
include $(PARSE_DOT_MK)
$(info including $(FORMAT_DOT_MK))
include $(FORMAT_DOT_MK)
$(info including $(GROUP_DOT_MK))
include $(GROUP_DOT_MK)
endif

$(TYPEMAPLIST_DOT_MK): $(GROUPLIST_DOT_MK) $(MODULE_DOT_CONF)     \
                       $(TYPEMAP_DOT_IGNORE) $(TYPEMAP_DOT_SIMPLE)\
                       $(TYPEMAP_DOT_MANUAL)                      \
                       $(filter-out %.friend %.function,$(GROUP_YAMLS))
	$(shell $(CMD_RM) $(TYPEMAP_DOT_DEP))
	$(foreach i,$^,$(shell $(CMD_ECHO) $(i) >> $(TYPEMAP_DOT_DEP)))
	$(_Q)$(CMD_RMDIR) $(OUT_TYPEMAP_DIR)
	$(_Q)[[ -d $(OUT_TYPEMAP_DIR) ]] || $(CMD_MKDIR)         \
        $(OUT_TYPEMAP_DIR)
	$(_Q)echo generating $(TYPEMAP_DRAFT)
	$(_Q)[[ -d $(dir $@) ]] || $(CMD_MKDIR) $(dir $@)
	$(_Q)$(CMD_CREAT_TP) $(MODULE_DOT_CONF)                  \
        $(TYPEMAP_DOT_IGNORE) $(TYPEMAP_DOT_SIMPLE)          \
        $(TYPEMAP_DOT_MANUAL) $(TYPEMAP_DOT_DEP)             \
        $(OUT_TYPEMAP_DIR) $(TYPEMAP_TEMPLATE_DRAFT) $(TYPEMAP_DRAFT)
	$(_Q)echo generating $(TYPEMAP)
	$(_Q)$(CMD_TYPEMAP) -t $(TYPEMAP_DOT_TT2) -t $(TYPEMAP2_DOT_TT2) \
        -o $(TYPEMAP)  -d $(IN_TYPEMAP_DIR)                  \
        $(TYPEMAP_DRAFT) $(TYPEMAP_TEMPLATE_DRAFT)
	$(_Q)echo generating $@
	$(_Q)$(CMD_TYPEMAPLIST_MK) $(OUT_TYPEMAP_DIR) $@

$(PACKAGEMAP)  : $(GROUP_DOT_MK) $(GROUPLIST_DOT_MK) $(GROUP_YAMLS)
	$(_Q)echo generating $@
	$(_Q)[[ -d $(dir $@) ]] || $(CMD_MKDIR) $(dir $@)
	$(_Q)$(CMD_PKGMAP) $(OUT_GROUP_DIR) $@

$(PACKAGEMAP2) : $(GROUP_DOT_MK) $(GROUPLIST_DOT_MK) $(GROUP_YAMLS)
	$(_Q)echo generating $@
	$(_Q)[[ -d $(dir $@) ]] || $(CMD_MKDIR) $(dir $@)
	$(_Q)$(CMD_PKGMAP_TEMPLATE) -o $(OUT_TEMPLATE_DIR) -template $(TEMPLATE_DIR) -meta $(MODULE_DOT_CONF) $(TYPEMAP_TEMPLATE)
	$(shell $(CMD_RM) $(TYPEMAP2_DOT_DEP))
	$(_Q)for i in `ls $(OUT_TEMPLATE_DIR)/*`; do $(CMD_ECHO) $$i >> $(TYPEMAP2_DOT_DEP); done

$(TYPEMAP2_DRAFT): $(TYPEMAP) $(MODULE_DOT_CONF) $(TYPEMAP_DOT_IGNORE) \
                   $(TYPEMAP_DOT_SIMPLE) $(TYPEMAP_DOT_MANUAL) $(PACKAGEMAP2)
	$(_Q)echo generating $(TYPEMAP2_DRAFT)
	$(_Q)$(CMD_CREAT_TP) $(MODULE_DOT_CONF)                \
      $(TYPEMAP_DOT_IGNORE) $(TYPEMAP_DOT_SIMPLE)          \
      $(TYPEMAP_DOT_MANUAL) $(TYPEMAP2_DOT_DEP)            \
      $(OUT_TEMPLATE_DIR) $(TYPEMAP2_TEMPLATE_DRAFT) $(TYPEMAP2_DRAFT) \
      -typemap $(TYPEMAP)

$(TYPEMAP2): $(TYPEMAP2_DRAFT)
	$(_Q)echo generating $@
	$(_Q)$(CMD_TYPEMAP) -t $(TYPEMAP_DOT_TT2) -t $(TYPEMAP2_DOT_TT2) \
      -o $(TYPEMAP2)  -d $(OUT_TEMPLATE_DIR)                         \
      $(TYPEMAP2_DRAFT) $(TYPEMAP2_TEMPLATE_DRAFT)

$(ENUMMAP)     : $(filter %.enum,$(GROUP_YAMLS))
	$(_Q)echo generating $@
	$(_Q)[[ -d $(dir $@) ]] || $(CMD_MKDIR) $(dir $@)
	$(_Q)$(CMD_ENUMMAP) -dir $(OUT_GROUP_DIR) -conf $(MODULE_DOT_CONF) -o $@

$(TYPEMAP_XS)  : $(TYPEMAPLIST_DOT_MK) $(PACKAGEMAP) $(GROUP_YAMLS) \
                 $(PACKAGEMAP2)
	$(_Q)echo generating $@
	$(_Q)$(CMD_TYPEMAP_XS) -conf $(MODULE_DOT_CONF)  \
      -manifest $(TYPEMAP_DOT_DEP) -manifest $(TYPEMAP2_DOT_DEP) \
	  -packagemap $(PACKAGEMAP) -packagemap $(PACKAGEMAP2) -o $@

$(ROOT_XS)     : $(TYPEMAPLIST_DOT_MK) $(GROUP_YAMLS) $(PACKAGEMAP2)
	$(_Q)echo generating $@
	$(_Q)$(CMD_ROOT_XS) -manifest $(TYPEMAP_DOT_DEP) -manifest $(TYPEMAP2_DOT_DEP) \
          -conf $(MODULE_DOT_CONF) -mk $(XSCODE_DOT_MK) -o $@

$(MAKEFILE_PL) : $(MODULE_DOT_CONF) $(CONFIG_DOT_MK)
	$(_Q)echo generating $@
	$(_Q)$(CMD_MAKEFILE_PL) -conf $(MODULE_DOT_CONF)         \
        -mk $(CONFIG_DOT_MK) -template $(TEMPLATE_DIR) -o $@

$(00USE_T)     : $(MODULE_DOT_CONF) $(PM_FILES)
	$(_Q)echo generating $@
	$(_Q)if [[ ! -d $(dir $@) ]]; then $(CMD_MKDIR) $(dir $@); fi
	$(_Q)$(CMD_00USE_T) -conf $(MODULE_DOT_CONF)             \
        -template $(TEMPLATE_DIR) -o $@

$(MANIFEST)    : $(XS_FILES) $(PM_FILES) $(00USE_T)
	$(_Q)echo generating $@
	$(_Q)$(CMD_MANIFEST) -conf $(MODULE_DOT_CONF)            \
        -template $(TEMPLATE_DIR) -o $@

$(MAKEFILE_PERL) : $(MAKEFILE_PL)
	$(_Q)echo generating $@
	$(_Q)$(CMD_PERL) $^

#################### GENERIC RULES #############################

clean_dot_mk :
	$(_Q)$(call _remove_file,$(HEADER_DOT_MK))
	$(_Q)$(call _remove_file,$(STRIP_DOT_MK))
	$(_Q)$(call _remove_file,$(PREPRO_DOT_MK))
	$(_Q)$(call _remove_file,$(PARSE_DOT_MK))
	$(_Q)$(call _remove_file,$(FORMAT_DOT_MK))
	$(_Q)$(call _remove_file,$(GROUP_DOT_MK))
	$(_Q)$(call _remove_file,$(GROUPLIST_DOT_MK))
	$(_Q)$(call _remove_file,$(XSCODE_DOT_MK))
	$(_Q)$(call _remove_file,$(TYPEMAPLIST_DOT_MK))
.PHONY: clean_dot_mk

gen_strip    : $(STRIP_HEADERS)
clean_strip  :
	$(_Q)$(call _remove_file,$(STRIP_DOT_MK))
	$(_Q)$(call _remove_dir,$(OUT_STRIP_DIR))
.PHONY: gen_strip clean_strip

gen_prepro   : gen_strip $(PREPRO_HEADERS)
clean_prepro :
	$(_Q)$(call _remove_file,$(PREPRO_DOT_MK))
	$(_Q)$(call _remove_dir,$(OUT_PREPRO_DIR))
.PHONY: gen_prepro clean_prepro

gen_parse    : gen_prepro $(PARSE_HEADERS)
clean_parse  :
	$(_Q)$(call _remove_file,$(PARSE_DOT_MK))
	$(_Q)$(call _remove_dir,$(OUT_PARSE_DIR))
.PHONY: gen_parse clean_parse

gen_format   : gen_parse $(FORMAT_YAMLS)
clean_format :
	$(_Q)$(call _remove_file,$(FORMAT_DOT_MK))
	$(_Q)$(call _remove_dir,$(OUT_FORMAT_DIR))
.PHONY: gen_format clean_format

gen_group    : gen_format $(GROUP_DOT_MK) $(GROUPLIST_DOT_MK)
clean_group  :
	$(_Q)$(call _remove_dir,$(OUT_GROUP_DIR))
	$(_Q)$(call _remove_file,$(GROUP_DOT_MK))
	$(_Q)$(call _remove_file,$(GROUPLIST_DOT_MK))
.PHONY: gen_group clean_group

gen_mapfile  : gen_group $(GROUPLIST_DOT_MK) $(TYPEMAPLIST_DOT_MK) \
               $(GROUP_YAMLS) $(PACKAGEMAP) $(ENUMMAP)
clean_mapfile:
	$(_Q)$(call _remove_dir,$(OUT_TYPEMAP_DIR))
	$(_Q)$(call _remove_file,$(TYPEMAPLIST_DOT_MK))
.PHONY: gen_mapfile clean_mapfile

gen_template : gen_mapfile $(PACKAGEMAP2) $(TYPEMAP2)
clean_template:
	$(_Q)$(call _remove_dir,$(OUT_TEMPLATE_DIR))
.PHONY: gen_template clean_template

# TODO: support of custom-inserted class meta files detection
#       keep a custom list in seperate file
gen_xscode   : gen_template $(XSCODE_DOT_MK)                    \
               $(XS_FILES) $(TYPEMAP_XS) $(ROOT_XS)
	$(_Q)if [[ ! -e xs ]]; then $(CMD_SYMLINK) $(OUT_XSCODE_DIR) xs; fi
clean_xscode :
	$(_Q)$(call _remove_dir,$(OUT_XSCODE_DIR))
	$(_Q)$(call _remove_file,$(XSCODE_DOT_MK))
	$(_Q)$(call _remove_file,$(TYPEMAP_XS))
	$(_Q)$(call _remove_file,$(ROOT_XS))
.PHONY: gen_xscode clean_xscode

gen_pmcode   : gen_xscode $(XS_FILES) $(PM_FILES)
	$(_Q)echo copying $(OUT_PMCODE_DIR) to lib
	$(_Q)$(CMD_RMDIR) lib blib
	$(_Q)$(CMD_CPDIR) $(OUT_PMCODE_DIR) lib
clean_pmcode :
	$(_Q)$(call _remove_dir,$(OUT_PMCODE_DIR))
.PHONY: gen_pmcode clean_pmcode

include $(BUILD_DOT_MK)

test         : $(00USE_T)
	$(_Q)$(MAKE) -f Makefile test
clean_test   :
	$(_Q)$(call _remove_file,$(00USE_T))
.PHONY: test clean_test

# utility
class_sanity_check:
	$(_Q)$(CMD_GROUP_CHECK) $(OUT_GROUP_DIR)
.PHONY: class_sanity_check

list_group_yamls :
	$(_Q)echo # $(_GOALS)
	$(_Q)echo # $(GROUP_YAMLS)

list_typemap_yamls :
	$(_Q)echo # $(TYPEMAP_YAMLS)

list_template_types: $(TYPEMAP_TEMPLATE_DRAFT)
	$(_Q)$(CMD_YGREP) -f name $< | sort | uniq | cut -d':' -f2

list_template_def  : $(TYPEMAP_TEMPLATE_DRAFT)
	$(_Q)$(CMD_YGREP) -c name=$(TEMPLATE_NAME) $<

list_typemap_types :
	$(_Q)cut -d':' -f2 $(TYPEMAP_DRAFT) | sort | uniq
.PHONY: list_group_yamls list_typemap_yamls list_template_types \
        list_template_def list_typemap_types

list_xs_files      :
	$(_Q)echo # $(XS_FILES)
list_pm_files      :
	$(_Q)echo # $(PM_FILES)
.PHONY: list_xs_files list_pm_files

# final assignment
clean: clean_dot_mk clean_strip clean_prepro clean_parse       \
       clean_format clean_group clean_mapfile clean_template   \
       clean_xscode clean_pmcode clean_build clean_test
	$(_Q)if [[ -L xs ]]; then $(CMD_RM) xs; fi
	$(_Q)if [[ -L lib ]]; then $(CMD_RM) lib; fi
.PHONY: clean

all: gen_pmcode
