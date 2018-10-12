#!/bin/bash
# Joseph Polizzotto (UC Berkeley)
# 408-996-6044
# www.htctu.net
# This script runs on a macOS

FULLFILE=$1

FILE="${FULLFILE%%.*}"

pandoc $FILE.docx --extract-media=$FILE -o $FILE.markdown

# error when Tex2svg encunters LaTeX delimter followed immediately by negative symbol
sed -i 's/$-/$\ -/g' $FILE.markdown

pandoc $FILE.markdown --webtex=http://latex.codecogs.com/svg.latex? -t epub2 --epub-cover-image=./cover.png -o $FILE.epub ./Title.txt --toc --toc-depth=2

mv $FILE.epub $FILE.zip

unzip $FILE.zip -d ./EPUB3_book

rm -r $FILE.zip

cd ./EPUB3_book

# Add Lang attribute for all documents (en-us)

find . -name '*.xhtml' -type f -exec sed -i 's/\/2007\/ops"/\/2007\/ops" lang="en" xml:lang="en"/g' {} \;

sed -ri "s@alt=\"cover image\"@$(cat ../Cover.txt)@g" ./EPUB/text/cover.xhtml

# Add title elements to Cover and Title Pages

find . -name 'title_page.xhtml' -type f -exec sed -i 's/<title>Title<\/title>/<title>Title Page<\/title>/g' {} \;

find . -name 'cover.xhtml' -type f -exec sed -i 's/<title>Title<\/title>/<title>Cover Page<\/title>/g' {} \;

## Repackage

7z a -tzip $FILE.zip *

cd ..

mv $FILE.zip $FILE.epub

rm -R ./EPUB3_book

rm $FILE.markdown


exit 0