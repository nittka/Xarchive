package de.nittka.tooling.xarchive.ui.validation

import de.nittka.tooling.xarchive.validation.XarchiveValidator
import de.nittka.tooling.xarchive.xarchive.Document
import de.nittka.tooling.xarchive.xarchive.XarchivePackage
import javax.inject.Inject
import org.eclipse.core.resources.IWorkspace
import org.eclipse.core.runtime.Path
import org.eclipse.xtext.validation.Check
import de.nittka.tooling.xarchive.xarchive.DocumentFileName
import de.nittka.tooling.xarchive.ui.XarchiveFileURIs

class XarchiveUIValidator extends XarchiveValidator {

	@Inject IWorkspace ws;

	@Check
	def checkFileExistence(DocumentFileName file) {
		if((file.eContainer as Document).futureDoc){
			//referenced file need not exists
			return
		}
		val referencedResouce=XarchiveFileURIs.getReferencedResourceURI(file)
		if(referencedResouce!==null){
			val referencedIFile=ws.root.getFile(new Path(referencedResouce.toPlatformString(true)))
			if(!referencedIFile.exists){
				error('''«referencedResouce.lastSegment» does not exists''', XarchivePackage.Literals.DOCUMENT_FILE_NAME__FILE_NAME)
			}
		}
	}
}