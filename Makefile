thumbnail.png: test/test-01-readme.pdf
	pdftoppm test/test-01-readme.pdf tmp-01 -png
	magick montage tmp-01-*png -geometry +2+2 -tile 4x2 thumbnail.png
	rm -v tmp-01-*png

