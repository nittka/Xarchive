package de.nittka.tooling.xarchive.ui;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.Path;
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

	public static IFile getXarchiveFile(IFile file){
		if("xarch".equals(file.getFileExtension())){
			throw new IllegalArgumentException(file+" is already an Xarchive file");
		}
		IPath path = file.getFullPath().removeFileExtension().addFileExtension("xarch");
		IFile xarchiveFile=file.getParent().getFile(new Path(path.lastSegment()));
		return xarchiveFile;
	}
}
