package de.nittka.tooling.xarchive.ui.linking;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.resource.DefaultLocationInFileProvider;
import org.eclipse.xtext.util.ITextRegion;

import de.nittka.tooling.xarchive.xarchive.Document;

public class XarchiveLocationInFileProvider extends
		DefaultLocationInFileProvider {

	@Override
	public ITextRegion getSignificantTextRegion(EObject obj) {
		if(obj instanceof Document){
			Document doc = ((Document) obj);
			if(doc.getFile() != null){
				return getFullTextRegion(doc.getFile());
			}
		}
		return super.getSignificantTextRegion(obj);
	}
}
