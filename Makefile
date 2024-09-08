thumbnail.png: stencil/main.pdf
	pdftoppm -scale-to 480 -f 1 -l 7 -o $< tmp-01 -png
	magick montage tmp-01-*png -geometry +1+0 -tile 4x2 thumbnail.png
	rm -v tmp-01-*png

