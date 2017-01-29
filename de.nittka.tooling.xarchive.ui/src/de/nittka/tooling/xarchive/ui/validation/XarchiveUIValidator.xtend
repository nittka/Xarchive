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

	public static val MISSING_XARCHIVE_FILE="missingXarch"

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
					IFile case resource.location.removeFileExtension.lastSegment.endsWith("_"): return false
					IFile: {
						val target=XarchiveFileURIs.getXarchiveFile(resource)
						if(!target.exists){
							val projectRelative=resource.projectRelativePath
							error('''no Xarchive file for «projectRelative»''', XarchivePackage.Literals.ARCHIVE_CONFIG__TYPES, 
								MISSING_XARCHIVE_FILE, resource.name, resource.fullPath.toString)
						}
						return false
					}
					default: throw new IllegalStateException("unknown case "+resource)
				}
			])
		}
	}
}