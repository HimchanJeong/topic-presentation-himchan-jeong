## define the name of source files as below
rmd_source := template.Rmd

## corresponding output names
pdf_out := $(patsubst %.Rmd,%.pdf,$(rmd_source))
html_out := $(patsubst %.Rmd,%.html,$(rmd_source))


.PHONY: all
all: $(pdf_out) $(html_out)

.PHONY: pdf
pdf: $(pdf_out)

$(pdf_out): $(rmd_source) _output.yml
	@make -s check
	@echo "compiling to pdf file..."
	@Rscript -e \
	"rmarkdown::render('$(rmd_source)', 'bookdown::pdf_document2')" \
	--vanilla

.PHONY: html
html: $(html_out)

$(html_out): $(rmd_source) _output.yml
	@make -s check
	@echo "compiling to pdf file..."
	@Rscript -e \
	"rmarkdown::render('$(rmd_source)', 'bookdown::html_document2')" \
	--vanilla

.PHONY: check
check:
	@Rscript -e \
	"foo <- 'bookdown' %in% installed.packages()[, 'Package'];" \
	-e "if (! foo) install.packages('bookdown')" --vanilla

.PHONY: clean
clean:
	rm -rf .Rhistory *\#* .\#* *~

.PHONY: rmCache
rmCache:
	rm -rf *_files *_cache