SOURCE ?= progress.tex
TARGET ?= $(SOURCE:.tex=.dvi)

VIEW	 := osascript -e "tell application \"Skim\" to revert document \"$(TARGET)\"" || open -a Skim "$(TARGET)"

default: $(TARGET)

### Checking for dependencies ################################################
ifneq ($(strip $(shell grep '^[^%]*\\\(auto\|page\|name\|\)ref' $(SOURCE))),)
DEPS += %.aux
endif

ifneq ($(strip $(shell grep '^[^%]*\\tableofcontents' $(SOURCE))),)
DEPS += %.toc
endif

ifneq ($(strip $(shell grep '^[^%]*\\listoffigures' $(SOURCE))),)
DEPS += %.lof
endif

ifneq ($(strip $(shell grep '^[^%]*\\listoftables' $(SOURCE))),)
DEPS += %.lot
endif

ifneq ($(strip $(shell grep '^[^%]*\\printindex' $(SOURCE))),)
DEPS += %.ind
endif

ifneq ($(strip $(shell grep '^[^%]*\\printglossary' $(SOURCE))),)
DEPS += %.gls
endif

ifneq ($(strip $(shell grep '^[^%]*\\printnomenclature' $(SOURCE))),)
DEPS += %.nls
endif

ifneq ($(strip $(shell grep '^[^%]*\\bibliography{[^}]*}' $(SOURCE))),)
DEPS += %.bbl
BIBDB	:= $(strip $(shell grep '^[^%]*\\bibliography{[^}]*}' $(SOURCE) | sed 's/.*{\(.*\).*}/\1/' ))
ifeq ($(strip $(shell echo $(BIBDB) | grep bib)),)
BIBDB :=$(BIBDB).bib
endif
endif

FIGURES := $(shell grep "^[^%]*\\includegraphics[{\[]" $(SOURCE) | sed 's/.*{\([^}]*\)}.*/\1/')
INCLUDES := $(filter %.tex,$(shell grep "^[^%]*\\in\(clude\|put\)[{\[]" $(SOURCE) | sed 's/.*{\([^}]*\)}.*/\1/'))

### Specific project rules ###################################################

### Rules for LaTeX ##########################################################
# Remove default rule
%.dvi : %.tex

list_deps:
	@echo $(TARGET) depends on $(DEPS) $(filter %.pdf,$(FIGURES)) $(INCLUDES)

view: $(TARGET)
	$(VIEW)

%.aux %.idx %.lof %.lot %.nlo %.glo %.toc: %.tex | $(INCLUDES) $(filter %.eps,$(FIGURES))
	latex $<

%.ind: %.idx
	makeindex $<

%.bbl: %.aux $(BIBDB)
	bibtex $<

%.gls: %.glo
	makeindex $< -s nomencl.ist -o $@

%.nls: %.nlo
	makeindex $< -s nomencl.ist -o $@

%.pdf: %.eps
	epstopdf --outfile="$@" "$<"

%.pdf: %.tex $(INCLUDES) $(DEPS) $(filter %.pdf,$(FIGURES))
	pdflatex $<

%.dvi: %.tex $(INCLUDES) $(DEPS) $(filter %.eps,$(FIGURES))
	latex $<

%.ps: %.dvi
	dvips -o $@ -t a4 $<

clean:
	rm -f *.aux *.bbl *.blg *.glo *.gls *.idx *.ilg *.ind *.lof *.log *.lot *.out *.toc

clean_all: clean
	rm -f *.pdf *.dvi

.PHONY: default clean clean_all view list_deps
.SECONDARY:
