# Dart script to migrate wiki pages to markdown

This is a Dart script written to migrate wiki pages to markdown.
It:

* Downloads the images
* Converts the wiki page into mark-down using the input file name as template to generate the target file name

# Open issues

Incorrectly format code in the wiki page is (in some case) duplicated in the output.
Documents with special characters or spaces may result in broking links. But than again, using such characters was not smart in the first place, right? Now you have to pay for it with manual work.  ;-)
Classification tags in the wiki are present in the output, you may want to delete it in the output 

# Usage

* Open the migrate.dart file and change the wikiPageUrls, listing all the pages you want to migrate.
* Change the imageRepository to the repo you migrating your wiki pages to

Afterwards run the script, output is copied into the "docs" folder (can be changed in the script)

dart migrate.dart 

# Checking the merge result

`dart linkchecker.dart` can be used to checked broken links the resulting mark-down pages. Adjust rawUrls in the script to customize the checked pages.
Ensure you use the https://raw.githubusercontent.com/ URL to avoid checking the Github links in your mark-downpage
  
