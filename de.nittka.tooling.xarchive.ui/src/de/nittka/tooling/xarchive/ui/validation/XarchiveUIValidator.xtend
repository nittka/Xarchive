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
import org.eclipse.xtext.validation.CheckType
import de.nittka.tooling.xarchive.xarchive.ArchiveConfig
import org.eclipse.core.resources.IContainer
import org.eclipse.core.resources.IFile

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

	@Check(CheckType.NORMAL)
	def checkAllFilesHaveDescription(ArchiveConfig config) {
		val file=ws.root.getFile(new Path(config.eResource.URI.toPlatformString(true)))
		if(file.exists){
			val project=file.project
			project.accept([resource|
				switch(resource){
					IContainer: return true
					IFile case resource.fileExtension=="xarch": return false
					IFile case resource.name==".project": return false
					IFile: {
						if(!XarchiveFileURIs.getXarchiveFile(resource).exists){
							error('''no Xarchive file for «resource.projectRelativePath»''', XarchivePackage.Literals.ARCHIVE_CONFIG__TYPES)
						}
						return false
					}
					default: throw new IllegalStateException("unknown case "+resource)
				}
			])
		}
	}
}