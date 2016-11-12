package de.nittka.tooling.xarchive.ui.linking;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.jface.text.Region;
import org.eclipse.xtext.nodemodel.ICompositeNode;
import org.eclipse.xtext.nodemodel.util.NodeModelUtils;
import org.eclipse.xtext.resource.EObjectAtOffsetHelper;
import org.eclipse.xtext.resource.XtextResource;
import org.eclipse.xtext.ui.editor.hyperlinking.HyperlinkHelper;
import org.eclipse.xtext.ui.editor.hyperlinking.IHyperlinkAcceptor;
import org.eclipse.xtext.ui.editor.hyperlinking.XtextHyperlink;

import com.google.inject.Inject;

import de.nittka.tooling.xarchive.ui.XarchiveFileURIs;
import de.nittka.tooling.xarchive.xarchive.DocumentFileName;

public class XarchiveHyperlinkHelper extends HyperlinkHelper {

	@Inject
	private EObjectAtOffsetHelper eObjectAtOffsetHelper;

	public void createHyperlinksByOffset(XtextResource resource, int offset, IHyperlinkAcceptor acceptor) {
		EObject element = eObjectAtOffsetHelper.resolveElementAt(resource, offset);
		if(element instanceof DocumentFileName){
			createHyperlinkForReferencedFile((DocumentFileName)element, acceptor);
		}else{
			super.createHyperlinksByOffset(resource, offset, acceptor);
		}
	}

	private void createHyperlinkForReferencedFile(DocumentFileName file, IHyperlinkAcceptor acceptor){
		URI uri = XarchiveFileURIs.getReferencedResourceURI(file);
		if(uri!=null){
			ICompositeNode node = NodeModelUtils.findActualNodeFor(file);
			Region region=new Region(node.getOffset(), node.getLength());
			XtextHyperlink hyperlink = getHyperlinkProvider().get();
			hyperlink.setHyperlinkRegion(region);
			hyperlink.setURI(uri);
			hyperlink.setHyperlinkText("open File");
			acceptor.accept(hyperlink);
		}
	}
}
