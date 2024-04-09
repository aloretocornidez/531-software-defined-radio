
# Simple Makefile to compile my pdf.


output="output.pdf"
input="report.md"

.PHONY: all

all:
	pandoc --from=markdown --to=latex --template=template.latex --output=${output} ${input}
	# firefox ${output}
