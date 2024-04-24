# Dart script to migrate wiki pages to markdown

This is a Dart script written to migrate wiki pages to markdown.
Requires dart installed on the machine.

It:

* Downloads the images
* Converts the wiki page into mark-down using the input file name as template to generate the target file name

# Open issues / work left to be done

* Incorrectly format code in the wiki page :angry: is (in some case) duplicated in the output, manually delete the first included code
* Documents with special characters or spaces :scream: may result in broking links. But than again, using such characters was not smart in the first place, right? Now you have to pay for it with manual work.  :wink:
* Classification tags in the wiki are present in the output, you may want to delete it in the output 

# Usage

* Open the migrate.dart file and change the wikiPageUrls, listing all the pages you want to migrate.
* Change the imageRepository to the repo you migrating your wiki pages to

Afterwards run the script, output is copied into the `docs` folder (can be changed in the script)

`dart migrate.dart`


Copy this folder to your target repo and create a pull request to get in merged. :sunglasses:


# Checking the links the in markdown documents

Once merged into the repo you can check for broken links with another script.
`dart linkchecker.dart` can be used to checked broken links the listed mark-down pages. 

Adjust rawUrls in the script to customize the checked pages.
Ensure you use the https://raw.githubusercontent.com/ URL to avoid checking the Github links in your mark-downpage
  
# Add a note to the wiki that the page has been migrated

To be friendly to your users and if the wiki is still in edit mode, add a note to the wiki that the page has been migrated, something like:

`{{Warning|This page has been migrated to to https://github.com/eclipse-platform/eclipse.platform.ui/blob/master/docs/JFaceDataBinding.md.}}`

