package de.nittka.tooling.xarchive.ui.search

import de.nittka.tooling.xarchive.xarchive.AndSearchExpression
import de.nittka.tooling.xarchive.xarchive.Category
import de.nittka.tooling.xarchive.xarchive.CategorySearch
import de.nittka.tooling.xarchive.xarchive.NegationSearchExpression
import de.nittka.tooling.xarchive.xarchive.OrSearchExpression
import de.nittka.tooling.xarchive.xarchive.Search
import de.nittka.tooling.xarchive.xarchive.SearchExpression
import de.nittka.tooling.xarchive.xarchive.SearchReference
import de.nittka.tooling.xarchive.xarchive.TagSearch
import de.nittka.tooling.xarchive.xarchive.XarchivePackage
import java.util.ArrayList
import java.util.Collections
import java.util.List
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.resource.IResourceDescription
import org.eclipse.xtext.resource.IEObjectDescription
import de.nittka.tooling.xarchive.xarchive.DescriptionSearch

//TODO prevent SearchReference loops
//TODO refine tag and description search
//TODO introduce date and reference search?
class XarchiveSearch {

	Search search;
	IResourceDescription desc
	IProgressMonitor monitor

	new (Search search) {
		this.search=search;
	}

	def Resource getResource(){
		return search.eResource();
	}

	def boolean matches(IResourceDescription description, IProgressMonitor monitor){
		this.desc=description
		this.monitor=monitor
		if(exportedDocuments.empty){
			//this is not a "describing" xarchive document
			return false
		}else{
			return apply(search.search)
		}
	}

	def private List<IEObjectDescription> getExportedDocuments(){
		return desc.getExportedObjectsByType(XarchivePackage.Literals.DOCUMENT).toList
	}

	def private boolean apply(SearchExpression expression){
		return !monitor.canceled && internalApply(expression)
	}

	def private dispatch boolean internalApply(SearchExpression exp){
		throw new UnsupportedOperationException("missing search implementation for "+exp.class)
	}

	def private dispatch boolean internalApply(NegationSearchExpression exp){
		return !apply(exp.negated)
	}

	def private dispatch boolean internalApply(SearchReference exp){
		return apply(exp.search.search)
	}

	def private dispatch boolean internalApply(OrSearchExpression exp){
		return apply(exp.left) || apply(exp.right)
	}

	def private dispatch boolean internalApply(AndSearchExpression exp){
		return apply(exp.left) && apply(exp.right)
	}

	def private dispatch boolean internalApply(TagSearch exp){
		val tags=exportedDocuments.map[it.getUserData("tags")].filterNull.map[it.split(";").toList].flatten.toList
		return tags.contains(exp.tag)
	}

	def private dispatch boolean internalApply(DescriptionSearch exp){
		val descriptions=exportedDocuments.map[it.getUserData("desc")].filterNull.toList
		return descriptions.exists[desc|desc.contains(exp.description)]
	}

	def private dispatch boolean internalApply(CategorySearch exp){
		//TODO handle shortcut categories properly - after considering what the search semantics should be
		val referencedCategories=desc.referenceDescriptions
		.filter[EReference===XarchivePackage.Literals.CATEGORY_REF__CATEGORIES]
		.map[targetEObjectUri].toList
		return !Collections.disjoint(referencedCategories, getUrisToLookFor(exp))
	}

	def private List<URI> getUrisToLookFor(CategorySearch exp){
		val categoriesToLookFor=new ArrayList<URI>
		val category = exp.category.category
		val baseURI = resource.getURI();

		categoriesToLookFor.add(baseURI.appendFragment(resource.getURIFragment(category)))
		if(category.shortCuts.empty){
			if (exp.orBelow){
				EcoreUtil2.getAllContentsOfType(category, Category).forEach[
					categoriesToLookFor.add(baseURI.appendFragment(resource.getURIFragment(it)))
				]
			}
			if (exp.orAbove){
				var EObject parent=category.eContainer
				while(parent instanceof Category){
					categoriesToLookFor.add(baseURI.appendFragment(resource.getURIFragment(parent)))
					parent=parent.eContainer
				}
			}
		}
		return categoriesToLookFor
	}
}