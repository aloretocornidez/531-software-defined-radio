


.PHONY: all generate clean

all: pdf

generate: 
	@echo "Making Paper from markdown."
	pandoc -o ./proposal.tex ./project-proposal.md

paper: generate
	@echo "Making latex file."
	cat ./src/prologue ./proposal.tex ./src/epilogue | sed 's/\\tightlist//'> paper.tex
	
pdf: paper 
	@echo "Generating Pdf"
	pdflatex ./paper.tex
	rm -rf ./paper.aux ./paper.log ./paper.toc ./paper.tex ./proposal.tex ./texput.log ./project-proposal.tex
	@clear

clean:
	@echo "Cleaning up..."
	rm *.txt
