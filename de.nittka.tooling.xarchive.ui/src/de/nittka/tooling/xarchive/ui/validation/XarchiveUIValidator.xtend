package de.nittka.tooling.xarchive.ui.validation

import de.nittka.tooling.xarchive.validation.XarchiveValidator
import de.nittka.tooling.xarchive.xarchive.Document
import de.nittka.tooling.xarchive.xarchive.XarchivePackage
import javax.inject.Inject
import org.eclipse.core.resources.IWorkspace
import org.eclipse.core.runtime.Path
import org.eclipse.xtext.validation.Check

class XarchiveUIValidator extends XarchiveValidator {

	@Inject IWorkspace ws;

	@Check
	def checkFileExistence(Document doc) {
		if(doc.futureDoc){
			//referenced file need not exists
			return
		}
		val referencedResouce=doc.eResource.URI.trimSegments(1).appendSegment(doc.name).appendFileExtension(doc.extension)
		val file=ws.root.getFile(new Path(referencedResouce.toPlatformString(true)))
		if(!file.exists){
			error('''«referencedResouce.lastSegment» does not exists''', XarchivePackage.Literals.DOCUMENT__NAME)
		}
	}
}