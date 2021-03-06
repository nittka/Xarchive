/*******************************************************************************
 * Copyright (C) 2016-2020 Alexander Nittka (alex@nittka.de)
 * 
 * This program and the accompanying materials are made
 * available under the terms of the Eclipse Public License 2.0
 * which is available at https://www.eclipse.org/legal/epl-2.0/
 * 
 * SPDX-License-Identifier: EPL-2.0
 ******************************************************************************/
package de.nittka.tooling.xarchive.validation

import com.google.common.collect.Lists
import de.nittka.tooling.xarchive.xarchive.ArchiveConfig
import de.nittka.tooling.xarchive.xarchive.Category
import de.nittka.tooling.xarchive.xarchive.CategoryRef
import de.nittka.tooling.xarchive.xarchive.CategoryType
import de.nittka.tooling.xarchive.xarchive.Document
import de.nittka.tooling.xarchive.xarchive.DocumentFileName
import de.nittka.tooling.xarchive.xarchive.XarchivePackage
import java.util.List
import java.util.Set
import java.util.regex.Pattern
import javax.inject.Inject
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.resource.IEObjectDescription
import org.eclipse.xtext.resource.IResourceServiceProvider
import org.eclipse.xtext.resource.impl.ResourceDescriptionsProvider
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.CheckType

/**
 * Custom validation rules. 
 *
 * see http://www.eclipse.org/Xtext/documentation.html#validation
 */
class XarchiveValidator extends AbstractXarchiveValidator {

	val public static FILE_NAME="filename"
	val public static MISSING_CATEGORY="missingCategory"

	@Inject
	private ResourceDescriptionsProvider indexProvider
	@Inject
	private IResourceServiceProvider serviceProvider

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
		if(file.eContainingFeature==XarchivePackage.Literals.DOCUMENT__FILE && file.fileName!=resourceName){
			error('''illegal file name: '«resourceName»' expected''', XarchivePackage.Literals.DOCUMENT_FILE_NAME__FILE_NAME, FILE_NAME, file.fileName, resourceName)
		}
	}

	val static Pattern datePattern=Pattern.compile("\\d{4}(-\\d{2}){0,2}")

	@Check
	def checkDateFormant(Document doc) {
		if(doc.docDate!==null){
			if(!datePattern.matcher(doc.docDate).matches){
				error("illegal date format (yyyy, yyyy-mm, or yyyy-mm-dd)", XarchivePackage.Literals.DOCUMENT__DOC_DATE)
			}
		}
	}

	@Check
	def checkCategories(Document doc) {
		if(doc.categories.empty){
			error("at least one category must be defined", XarchivePackage.Literals.DOCUMENT__FILE)
		} else {
			val Set<Category> usedCategories=newHashSet;
			doc.categories.forEach[checkCategory(usedCategories)]

			val usedTypes=usedCategories.map[EcoreUtil2.getContainerOfType(it, CategoryType)].toSet
			val missingMandatoryTypes=Lists.newArrayList(doc.mandatoryTypes)
			missingMandatoryTypes.removeAll(usedTypes)

			missingMandatoryTypes.forEach[
				error("missing mandatory category type "+name, XarchivePackage.Literals.DOCUMENT__FILE, MISSING_CATEGORY, name)
			]
		}
	}

	def void checkCategory(CategoryRef ref, Set<Category> usedCategories){
		if(ref.categories.empty){
			error("at least one category must be defined", ref, XarchivePackage.Literals.CATEGORY_REF__TYPE)
		}else{
			(0..ref.categories.size-1).forEach[index|
				val cat=ref.categories.get(index)
				val catToCheck=newHashSet(cat)
				catToCheck.addAll(cat.shortCuts.map[category])
				catToCheck.forEach[toCheck|
					if(usedCategories.contains(toCheck)){
						error("duplicate category "+toCheck.name, ref, XarchivePackage.Literals.CATEGORY_REF__CATEGORIES, index)
					}else{
						usedCategories.addAll(toCheck.allCategories)
					}
				]
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

	@Check(CheckType.NORMAL)
	def checkAtMostOneConfig(ArchiveConfig config) {
		val List<IEObjectDescription>configs=newArrayList
		val index=indexProvider.getResourceDescriptions(config.eResource)
		val containerManager=serviceProvider.containerManager
		val visibleContainer=containerManager.getVisibleContainers(serviceProvider.resourceDescriptionManager.getResourceDescription(config.eResource), index)
		visibleContainer.forEach[
			configs.addAll(it.getExportedObjectsByType(XarchivePackage.Literals.ARCHIVE_CONFIG))
		]
		if(configs.size>1){
			error("there is more than one archive configuration file:"+configs.map[name.toString].join(", "), XarchivePackage.Literals.ARCHIVE_CONFIG__TYPES)
		}
	}
}
