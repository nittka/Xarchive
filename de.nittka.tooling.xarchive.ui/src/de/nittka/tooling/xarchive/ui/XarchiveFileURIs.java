package de.nittka.tooling.xarchive.ui;

import org.eclipse.emf.common.util.URI;

import de.nittka.tooling.xarchive.xarchive.DocumentFileName;

public class XarchiveFileURIs {

	public static URI getReferencedResourceURI(DocumentFileName file){
		try{
			return file.eResource().getURI().trimSegments(1).appendSegment(file.getFileName()).appendFileExtension(file.getExtension());
		}catch(Exception e){
			//partial name cannot reference existing file
			return null;
		}
	}
}
