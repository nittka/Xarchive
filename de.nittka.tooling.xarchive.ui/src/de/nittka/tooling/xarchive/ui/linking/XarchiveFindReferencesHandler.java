package de.nittka.tooling.xarchive.ui.linking;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.ui.editor.findrefs.FindReferencesHandler;

import de.nittka.tooling.xarchive.xarchive.DocumentFileName;

public class XarchiveFindReferencesHandler extends FindReferencesHandler {

	@Override
	protected void findReferences(EObject target) {
		if(target instanceof DocumentFileName){
			//find references for document rather than file name object
			super.findReferences(target.eContainer());
		}else{
			super.findReferences(target);
		}
	}
}
