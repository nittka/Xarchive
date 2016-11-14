/*
 * generated by Xtext
 */
package de.nittka.tooling.xarchive.validation

import de.nittka.tooling.xarchive.xarchive.Document
import org.eclipse.xtext.validation.Check
import de.nittka.tooling.xarchive.xarchive.CategoryType
import java.util.Set
import de.nittka.tooling.xarchive.xarchive.XarchivePackage
import de.nittka.tooling.xarchive.xarchive.DocumentFileName
import java.util.regex.Pattern
import java.util.List
import de.nittka.tooling.xarchive.xarchive.ArchiveConfig
import com.google.common.collect.Lists
import de.nittka.tooling.xarchive.xarchive.CategoryRef
import de.nittka.tooling.xarchive.xarchive.Category
import org.eclipse.xtext.EcoreUtil2

/**
 * Custom validation rules. 
 *
 * see http://www.eclipse.org/Xtext/documentation.html#validation
 */
class XarchiveValidator extends AbstractXarchiveValidator {

	val public static FILE_NAME="filename"
	val public static MISSING_CATEGORY="missingCategory"

	@Check
	def checkDuplicateCategory(Document doc) {
		val Set<CategoryType> types=newHashSet()
		doc.categories.forEach[
			val t=it.type
			if (types.contains(t)){
				error("duplicate category", it, XarchivePackage.Literals.CATEGORY_REF__TYPE)
			}else{
				types.add(t)
			}
		]
	}

	@Check
	def checkFileName(DocumentFileName file) {
		val resourceName=file.eResource.URI.trimFileExtension.lastSegment
		if(file.fileName!=resourceName){
			error('''illegal file name: '«resourceName»' expected''', XarchivePackage.Literals.DOCUMENT_FILE_NAME__FILE_NAME, FILE_NAME, file.fileName, resourceName)
		}
	}

	val static Pattern datePattern=Pattern.compile("\\d{4}(-\\d{2}){0,2}")

	@Check
	def checkDateFormant(Document doc) {
		if(doc.date!==null){
			if(!datePattern.matcher(doc.date).matches){
				error("illegal date format (yyyy, yyyy-mm, or yyyy-mm-dd)", XarchivePackage.Literals.DOCUMENT__DATE)
			}
		}
	}

	@Check
	def checkCategories(Document doc) {
		if(doc.categories.empty){
			error("at least one category must be defined", XarchivePackage.Literals.DOCUMENT__FILE)
		} else {
			val missingMandatoryTypes=Lists.newArrayList(doc.mandatoryTypes)
			doc.categories.forEach[missingMandatoryTypes.remove(it.type)]
			missingMandatoryTypes.forEach[
				error("missing mandatory category type "+name, XarchivePackage.Literals.DOCUMENT__FILE, MISSING_CATEGORY, name)
			]
			doc.categories.forEach[checkCategory]
		}
	}

	def void checkCategory(CategoryRef ref){
		if(ref.categories.empty){
			error("at least one category must be defined", ref, XarchivePackage.Literals.CATEGORY_REF__TYPE)
		}else{
			val Set<Category> usedCategories=newHashSet;
			(0..ref.categories.size-1).forEach[
				val cat=ref.categories.get(it)
				if(usedCategories.contains(cat)){
					error("duplicate category "+cat.name, ref, XarchivePackage.Literals.CATEGORY_REF__CATEGORIES, it)
				}else{
					usedCategories.addAll(cat.allCategories)
				}
			]
		}
	}

	/**
	 * returns all categories directly related to the given one
	 * (ancestors and descendants)
	 */
	def private List<Category> getAllCategories(Category cat){
		val List<Category> result=newArrayList
		result.add(cat)
		result.addAll(EcoreUtil2.eAllOfType(cat, Category))
		var parent=cat.eContainer
		while(parent instanceof Category){
			result.add(parent as Category)
			parent=parent.eContainer
		}
		result
	}

	def private List<CategoryType> getMandatoryTypes(Document doc){
		val ArchiveConfig config=doc.categories.get(0).type.eContainer as ArchiveConfig
		return config.types.filter[required].toList
	}
}
