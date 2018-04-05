#!/bin/bash
# Joseph Polizzotto (HTCTU)
# 408-996-6044
# www.htctu.net
# This script runs on a PC


for d in ./*/*;

do 

find . -name '*.DOCX' -type f -exec pandoc --extract-media={}_media -o {}.markdown {} \;

find . -name '*.markdown' -type f -exec sed -i 's/\\\\/\\/g' {} \;

find . -name '*.markdown' -type f -exec sed -i 's/\\\$/$/g' {} \;

find . -name '*.markdown' -type f -exec sed -i 's/\\^/^/g' {} \;

find . -name '*.markdown' -type f -exec sed -i 's/\\_/_/g' {} \;

find ./*chapter/ -name '*.markdown' -exec pandoc -t epub3 --epub-cover-image=./cover.png -o ./EPUB3_book.epub ./Title.txt --toc --toc-depth=2 {} +

mv EPUB3_book.epub EPUB3_book.zip

unzip EPUB3_book.zip -d ./EPUB3_book

rm -r EPUB3_book.zip

cd EPUB3_book

# Add Lang attribute for all documents (en-us)

find . -name '*.xhtml' -type f -exec sed -i 's/\/2007\/ops"/\/2007\/ops" lang="en" xml:lang="en"/g' {} \;

# Add Alt Text for cover image

sed -ri "s@alt=\"cover image\"@$(cat ../Cover.txt)@g" ./EPUB/text/cover.xhtml

# Remove redundant Fig Caption text (same as alt text)

find . -name 'ch*.xhtml' -type f -exec sed -ri 's/<figcaption>[^<]+<\/figcaption>/<figcaption><\/figcaption>/g' {} \;

# Add lang attribute to text (French is +++ and ===;Italian is @@@ and %%%; and Spanish is !!! and ???)

find . -name 'ch*.xhtml' -type f -exec sed -i 's/+++/<span xml:lang="fr" lang="fr">/' {} \;

find . -name 'ch*.xhtml' -type f -exec sed -i 's/===/<\/span>/' {} \;

find . -name 'ch*.xhtml' -type f -exec sed -i 's/@@@/<span xml:lang="it" lang="it">/' {} \;

find . -name 'ch*.xhtml' -type f -exec sed -i 's/%%%/<\/span>/' {} \;

find . -name 'ch*.xhtml' -type f -exec sed -i 's/!!!/<span xml:lang="es" lang="es">/' {} \;

find . -name 'ch*.xhtml' -type f -exec sed -i 's/???/<\/span>/' {} \;

# Add Page Break Attributes

find . -name 'ch*.xhtml' -type f -exec sed -i 's/<h6>/<p>/g' {} \;

find . -name 'ch*.xhtml' -type f -exec sed -i 's/<\/h6>/<\/p>/g' {} \;

find . -name 'ch*.xhtml' -type f -exec sed -i 's/class="level6"//g' {} \;

find . -name 'ch*.xhtml' -type f -exec sed -i 's/<section id="page/<section epub:type="pagebreak" role="doc-pagebreak" id="page/g' {} \;

find . -name 'ch*.xhtml' -type f -exec sed -i 's/epub:type="noteref"/epub:type="noteref" role="doc-noteref"/g' {} \;

find . -name 'ch*.xhtml' -type f -exec sed -i 's/epub:type="footnote"/epub:type="footnote" role="doc-footnote"/g' {} \;

find . -name 'ch*.xhtml' -type f -exec sed -i 's/class="footnote-back"/class="footnote-back" aria-label="Back to Text"/g' {} \;

find . -name 'ch*.xhtml' -type f -exec sed -i 's/page-[^page-]*$/&&/' {} \;

find . -name 'ch*.xhtml' -type f -exec sed -i 's/" >page-/" title="page /' {} \;

find . -name 'ch*.xhtml' -type f -exec sed -i 's/ >/>/' {} \;

# Add title elements to Cover and Title Pages

find . -name 'title_page.xhtml' -type f -exec sed -i 's/<title>Title<\/title>/<title>Title Page<\/title>/g' {} \;

find . -name 'cover.xhtml' -type f -exec sed -i 's/<title>Title<\/title>/<title>Cover Page<\/title>/g' {} \;

# Add accessibility metadata to OPF

find . -name 'content.opf' -type f -exec sed -i 's/<metadata xmlns:dc="http:\/\/purl.org\/dc\/elements\/1.1\/" xmlns:opf="http:\/\/www.idpf.org\/2007\/opf">/<metadata xmlns:dc="http:\/\/purl.org\/dc\/elements\/1.1\/" xmlns:opf="http:\/\/www.idpf.org\/2007\/opf"> <meta property="schema:accessibilitySummary">This publication conforms to WCAG 2.0 Level AA.<\/meta>/g' {} \;

find . -name 'content.opf' -type f -exec sed -i 's/<metadata xmlns:dc="http:\/\/purl.org\/dc\/elements\/1.1\/" xmlns:opf="http:\/\/www.idpf.org\/2007\/opf">/<metadata xmlns:dc="http:\/\/purl.org\/dc\/elements\/1.1\/" xmlns:opf="http:\/\/www.idpf.org\/2007\/opf"> <meta property="schema:accessModeSufficient">textual,visual<\/meta>/g' {} \;

find . -name 'content.opf' -type f -exec sed -i 's/<metadata xmlns:dc="http:\/\/purl.org\/dc\/elements\/1.1\/" xmlns:opf="http:\/\/www.idpf.org\/2007\/opf">/<metadata xmlns:dc="http:\/\/purl.org\/dc\/elements\/1.1\/" xmlns:opf="http:\/\/www.idpf.org\/2007\/opf"> <meta property="schema:accessMode">textual<\/meta>/g' {} \;

find . -name 'content.opf' -type f -exec sed -i 's/<metadata xmlns:dc="http:\/\/purl.org\/dc\/elements\/1.1\/" xmlns:opf="http:\/\/www.idpf.org\/2007\/opf">/<metadata xmlns:dc="http:\/\/purl.org\/dc\/elements\/1.1\/" xmlns:opf="http:\/\/www.idpf.org\/2007\/opf"> <meta property="schema:accessibilityFeature">MathML<\/meta>/g' {} \;

find . -name 'content.opf' -type f -exec sed -i 's/<metadata xmlns:dc="http:\/\/purl.org\/dc\/elements\/1.1\/" xmlns:opf="http:\/\/www.idpf.org\/2007\/opf">/<metadata xmlns:dc="http:\/\/purl.org\/dc\/elements\/1.1\/" xmlns:opf="http:\/\/www.idpf.org\/2007\/opf"> <meta property="schema:accessibilityFeature">structuralNavigation<\/meta>/g' {} \;

# Remove First </section> closing tag

find . -name 'ch*.xhtml' -type f -exec sed -i "0,/^<\/section>/s///" {} \;

# Remove empty lines

find . -name 'ch*.xhtml' -type f -exec sed -i '/^\s*$/d' {} \;

# Add </section> closing tag after page number attribute

find . -name 'ch*.xhtml' -type f -exec sed -i "0,/<\/p>/s//<\/p><\/section>/" {} \;

# Insert new line between first closing </p> tag and first closing </section>

find . -name 'ch*.xhtml' -type f -exec sed -i 's/<\/p><\/section>/<\/p>\n<\/section>/g' {} \;

# Add Aria Labels to page numbers ("Horizontal splitter" was read by VoiceOver)

find . -name 'ch*.xhtml' -type f -exec sed -i 's/title="page [0-9]*"/& ^&/' {} \;

find . -name 'ch*.xhtml' -type f -exec sed -i 's/\^title=/aria-label=/g' {} \;

# Collect Page Number Information

grep "pagebreak*" ./EPUB/text/*.xhtml > output.txt

sed -i 's/.\/EPUB\/text\//text\//' ./output.txt

sed -i 's/:<section epub:type="pagebreak" role="doc-pagebreak" id="/#/g' ./output.txt

sed -i 's/aria-label="page [0-9]*//g' ./output.txt 

sed -i 's/ ">//g' ./output.txt 

sed -i 's/page[^page]*$/&&/' ./output.txt

sed -i 's/title="page /title="/g' ./output.txt

sed -i 's/"page /">/' ./output.txt

sed -i 's/.$//' ./output.txt

sed -i 's/^/<li><a href="/' ./output.txt

sed -i 's/$/<\/a><\/li>/' ./output.txt

sed -i '1s/^/<ol class="toc">\n/' ./output.txt

sed -i '1s/^/<nav epub:type="page-list" role="doc-pagelist" id="pagelist"><h1 id="pagelist-title">Page Navigation<\/h1>\n/' ./output.txt

sed -i '$a\</ol>\' ./output.txt

# Append </nav> to the end of file

sed -i '$a\</nav>\' ./output.txt

# Clean Up NAV

find . -name 'nav.xhtml' -type f -exec sed -i 's/epub:type="toc"/epub:type="toc" role="doc-toc"/g' {} \;

find . -name 'nav.xhtml' -type f -exec sed -i 's/&gt;//g' {} \;

find . -name 'nav.xhtml' -type f -exec sed -i 's/&gt;//g' {} \;

# Add page-list nav to NAV document

sed -i '/<body>/r ./output.txt' ./EPUB/nav.xhtml

# Remove page number information file

rm ./output.txt

# ReZip and Convert
7z a -tzip "../EPUB3_book.zip" *

cd ..

mv EPUB3_book.zip EPUB3_book.epub

rm -R ./EPUB3_book

ace ./EPUB3_book.epub -o ./report  --force

kill -9 $PPID

done

exit
