package de.nittka.tooling.xarchive.ui.search;

import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.xtext.resource.IResourceDescription;

import de.nittka.tooling.xarchive.xarchive.Search;

//this class implements the actual logic of checking whether a given resource description matches the search
class XarchiveSearch {

	private Search search;

	public XarchiveSearch(Search search) {
		this.search=search;
	}

	public Resource getResource(){
		return search.eResource();
	}

	public boolean matches(IResourceDescription description, IProgressMonitor monitor){
		//this is where the logic goes
		//make sure to check whether the monitor has been cancelled
		return true;
	}
}
