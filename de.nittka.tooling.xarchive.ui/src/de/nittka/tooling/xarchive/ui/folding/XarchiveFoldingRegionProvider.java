package de.nittka.tooling.xarchive.ui.folding;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.nodemodel.ICompositeNode;
import org.eclipse.xtext.nodemodel.util.NodeModelUtils;
import org.eclipse.xtext.ui.editor.folding.DefaultFoldingRegionProvider;

import de.nittka.tooling.xarchive.xarchive.FullTextForSearch;

public class XarchiveFoldingRegionProvider extends DefaultFoldingRegionProvider {

	@Override
	protected boolean isHandled(EObject eObject) {
		if(eObject instanceof FullTextForSearch){
			ICompositeNode node = NodeModelUtils.findActualNodeFor(eObject);
			return node.getEndLine()-node.getStartLine()>2;
		}
		return false;
	}
}
