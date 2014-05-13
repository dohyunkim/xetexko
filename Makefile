NAME		= xetexko
TEXFILE		= $(NAME)-doc.tex
PDFFILE		= $(NAME)-doc.pdf
RUNFILES	= $(wildcard $(NAME)*.sty) $(wildcard hanja*.tab)
DOCFILES	= $(TEXFILE) $(PDFFILE) README ChangeLog
ZIPFILE		= $(NAME).zip
DO_LATEX	= texfot --quiet --tee=/dev/null xelatex $(TEXFILE)
FORMAT		= xetex
RUNDIR		= $(TEXMFDIR)/tex/$(FORMAT)/$(NAME)
DOCDIR		= $(TEXMFDIR)/doc/$(FORMAT)/$(NAME)
TEXMFDIR	= $(shell kpsewhich --var-value TEXMFHOME)
MYTMPFILE	= texfot.XXXXX

all: doc ctan

doc: $(PDFFILE)

$(PDFFILE): $(TEXFILE) $(RUNFILES)
	@$(DO_LATEX) | tee $(MYTMPFILE)
	@if( grep Rerun $(MYTMPFILE) ); then $(DO_LATEX); fi
	@$(RM) -f $(MYTMPFILE)

ctan: $(ZIPFILE)

$(ZIPFILE): $(RUNFILES) $(DOCFILES)
	@$(RM) -f $@
	@mkdir -p $(NAME) && cp $^ $(NAME)
	@zip -q -r -9 $@ $(NAME) && ls -l $@
	@$(RM) -rf $(NAME)

install: $(RUNFILES) $(DOCFILES)
	@echo Installing into: $(TEXMFDIR)
	@mkdir -p $(RUNDIR) && cp $(RUNFILES) $(RUNDIR)
	@mkdir -p $(DOCDIR) && cp $(DOCFILES) $(DOCDIR)

