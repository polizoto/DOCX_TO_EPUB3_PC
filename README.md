# DOCX_TO_EPUB3_PC
Convert DOCX files to EPUB 3 book (on a PC)

## Dependencies

- 7Zip: https://www.7-zip.org/
	- 7zip is a command line tool for zipping and unzipping files and folders
	- In our script, we use 7zip to unzip an EPUB and perform find and replace adjustments to the EPUB; we then rezip the book into an EPUB3
- pandoc: https://github.com/jgm/pandoc/releases/tag/2.1.2
	- Pandoc is a file converter command line program
	- In our script, we are converting DOCX files to Markdown; then we are converting Markdown to EPUB3
- ACE accessibility checker (uses Node.js): https://inclusivepublishing.org/toolbox/accessibility-checker/getting-started/#installation
	- ACE is a command line program for checking your EPUB against the Accessibility Standards (i.e., WCAG 2.0, EPUB 3.1)

Note: make the script executable by opening a terminal and entering the following command:
		- chmod + path/to/script.sh

## Usage

1. Create a folder directory

- Root Folder/
	- Title.txt
	- cover.png
	- cover.txt
	- 01_chapter/
		- 01_chapter.docx
	- 02_chapter/
		- 02_chapter.docx
	- 03_chapter/
		- 03_chapter.docx etc.

2. Create a metadata file for your EPUB (e.g., Title.txt)

- use YAML format:
	- Use --- at the beginning of the file
	- Use ... at the end of the file
- For example, the YAML block can contain:
`title:`
`creator:`
`publisher:` etc.

(See Title.txt file in this repo for an example of a YAML metadata block)

- Place the Title.txt file in the root folder
- Note: if you are using a different name or format for your metadata document, make sure to adjust the script (see below) so that the pandoc command contains the correct name and file extension (the default name for your metadata file in the script is "Title.txt")

3. Add an image file for your EPUB (e.g., Cover.jpg) + a custom alt text in a separate file (e.g., Cover.txt)
	- Place the cover.png file in the root folder
	- Note: if you are using a different name or format for your cover image file, make sure to adjust the script (see below) so that the pandoc command contains the correct name and file extension (the default name for your cover file in the script is "cover.png")
	- Place the cover.txt file in the root folder
	- Edit the Cover.txt file for the appropriate alternate text for the Cover.png
		- e.g., alt="EPUB logo"

4. Edit the chapter files in MS Word

	- add heading structure
		- mark page number as Heading #6 (if you added the word "page" in front of the page number (in ABBYY), you can do a regex find and replace (find what:page\ [0-9]; replace with: heading style 6) to convert all the page numbers to a Heading
	- format tables (repeat header row)
	- add alternate text for images
	- create math equations using MathType; then delete the image placeholder for the math
		- When all the equations have been entered, use the convert equations button (on the MathType ribbon)
			- select: MathType equations
			- Select Range: Whole document
			- Convert equations to Texvc(LaTeX delimiters)
			- unselect the checkboxes include translator name as a comment
			- unselect include MathType data as a comment
	- Mark up other languages in the following way (currently we allow up to four different languages in one book, where the default language for the whole book is en-US for English)
		- first language (default is French)
			- +++ (start of text)
			- === (end of text)
		- second language (default is Italian)
			- @@@ (start of text)
			- %%% (end of text)
		- third language (Default is Spanish)
			- !!! (start of text)
			- ??? (end of text)
		- Note: if your book has languages other than French, Italian, or Spanish, edit the script for the appropriate ISO values.

	(Repeat step 4 until every chapter of the book has been corrected and edited)

5. Use the bash script (DOCX_to_EPUB3.sh) to convert the DOCX files for each chapter into an EPUB 3 book (find the script attached to this email)

	- To run the script: open a terminal and enter this command from the root directory
		- ./DOCX_To_EPUB3_PC.sh
		- Press enter and wait for the script to execute
	- The script performs these functions:
		- Converts docx files to Markdown 
			- Note: Currently Pandoc cannot convert a DOCX file with LaTex Math to MathML when EPUB 3 is the output format specified; Pandoc has no problem, however, converting Markdown files + Latex to MathML when exporting to EPUB3
		- Corrects LaTeX syntax after Pandoc conversion from DOCX to Markdown
		- Converts Markdown files to EPUB 3
		- Adds epub:type markup to page numbers in document
		- creates a page-list nav section to NAV document
		- adds accessibility metadata to the package document
		- adds custom alternate text for the cover image
		- adds xml:lang attribute to all XHTML files, including up to four languages
		- Runs the ACE accessibility checker by DAISY to create an accessibility report on the EPUB 3 book

6. (OPTIONAL) Use Sigil to correct / edit EPUB information for accessibility 

- Note: our script adds this information automatically but there is need for human editing to confirm the access mode, accessibility summary, add accessibility features, accessibility hazards etc.
- Here are some example items that you may wish to edit/ add:
`<meta property="schema:accessibilitySummary">This publication conforms to WCAG 2.0 Level AA.</meta>`
`<meta property="schema:accessMode">textual</meta>`
`<meta property="schema:accessMode">visual</meta>`
`<meta property="schema:accessModeSufficient">textual,visual</meta>`
`<meta property="schema:accessibilityFeature">MathML</meta>`
- Save the Ebook and exit Sigil

7. (Optional) Use the ACE accessibility checker again to confirm that there are no errors:

	- ace ./EPUB3_book.epub -o ./report
	- Once the EPUB book has no errors, change the name of the EPUB to the name of the book
	
8. Open the book in an EPUB reading system that supports MathML

	- Use the Book Industry Standards Group website (www.BISG.org) to check which reading systems support MathML
	- we recommend the following reading systems that support MathML:
		- Vital Source Bookshelf
		- iBooks
