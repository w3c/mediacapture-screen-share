
all: screenshare.html  screenshare.diff.html


clean:
	- rm -f screenshare.diff.html screenshare.txt screenshare.orig.txt  

screenshare.txt: screenshare.html
	html2text.py screenshare.html | fold -bs -w 80 > screenshare.txt

screenshare.orig.txt: screenshare.orig.html
	html2text.py screenshare.orig.html | fold -bs -w 80 > screenshare.orig.txt

screenshare.diff.html: screenshare.orig.txt screenshare.txt
	htmlwdiff screenshare.orig.txt screenshare.txt > screenshare.diff.html
