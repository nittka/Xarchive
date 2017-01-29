# Xarchive

##Scope

This is intended to be a lightweight Xtext based Document management system. Within a single project you keep 
* a definition file for _categories_
* documents (scanned, pdf, etc.)
* for each document an `xarch` file containing meta data for this document (such as a list of applicable _categories_)

Supported meta data includes
* document name — name of the document
* date (precision year, month, day) — indicating the date for which the document is relevant
* (hard copy) reference — a file refernce indicating where a hardcopy of the file is stored
* list of (self defined) categories
* list of tags — additional keywords applying to the document
* description — **short** text describing the document
* list of references to other documents (along with description of the reference)
* full text search string — e.g. obtained via OCR

##Syntax

### definition file

```
//a category type may be mandatory
categoriesFor status required {
  done,
  //a category may have a description (e.g. shown in hover)
  metaDataIncomplete "doc is registered, but meta data has to be completed",
  //a category may have sub categories
  todo {
    URGENT,
    Normal,
    eventually,
    unPaid
  }
}

categoriesFor person {
  parents {
    mom, dad
  },
  children {
    daughter, son
  }
}

categoriesFor documentType {
  contract, receipt, pass, invoice, guarantee
}

categoriesFor scope {
  tax, work, health, housing, school
}

categoriesFor common {
  //a category may be a short cut for a combination of other categories
  schoolFeeDaughter shortcutFor (
    person:daughter,
    documentType: invoice,
    scope:school,
    scope: tax
  ),
  unpaidBill shortcutFor (
    status:unPaid,
    documentType:invoice
  )
}
```

### xarch file

```
//file name of the document
scrubFast.jpg
//optional namespace for unique seeAlso references
namespace invoices2012

date 2015-10-19
reference INV-2015-D6 

status: done;  
documentType: invoice, guarantee;
scope: housing;

tags: dishwasher, specialOffer;
description "new dishwasher bought at SuperTec for €395.95"

//see also reference to another document with optional description
->invoices1995.scrubSlow "old broken dishwasher"

'''
This is a full text of the document for text search.
It may be obtained using some OCR software

On opening the document this text will be "folded" 
(i.e. not immediately visible, so the meta data is not cluttered). 
'''

/* of course you can add additional information as 
 * single or multi line comment  
 */
```
Except for the document name (and required categories) all meta data is optional. Of course, the more meta data you provide, the better potential search results will be.
```
shoolingMay.pdf

date 2016-05-01
status: unPaid;
common:schoolFeeDaughter;
```

#Features

* define your own category hierarchies for describing your documents
* hover showing category descriptions (if you provided them)
* create new `xarch` file wizard
  * select a document and use the wizard to create the file with the correct file name already entered
* content assist
  * keywords
  * categories
  * documents for document references
  * write your own templates for common document types (some sample templates are shipped)
* validation (+ quickfixes for some)
  * document not found
  * missing `xarch` file for a document
  * missing mandatory category (if type is marked as required)
* navigation using F3
  * opening the original document
  * navigate to the category definition
  * navigate to the referenced document
* find references `Shift-Ctrl-G`
  * where is the given category used (excluding short cuts or via category hierarchy)
* define searches (invoked with `Alt-X` on the definition); matches are shown in the search view
  * search referenced categories, tags and descriptions
  * boolean operations
  * combine existing (named) searches

##Limitations

For simlicity file names, tags, categories etc. have a restricted character set (a-z, A-Z, digits, undersore and dash).

The `xarch` file must have the same file name as and be located next to the original document — only the file extension differs. Currently, documents without file extension are not supported.