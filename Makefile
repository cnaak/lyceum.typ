thumbnail.png: test/test-03-bkmatter.pdf
	pdftoppm -scale-to 480 $< tmp-01 -png
	magick montage tmp-01-*png -geometry +1+0 -tile 2x2 thumbnail.png
	rm -v tmp-01-*png

