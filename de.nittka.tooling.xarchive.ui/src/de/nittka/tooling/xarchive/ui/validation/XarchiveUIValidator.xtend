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
import java.util.List

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
			val List<String> ignorePatterns=if(config.ignore.nullOrEmpty)#[]else{
				config.ignore.map[it.replaceAll("\\.","\\\\.").replaceAll("\\*","\\.*").replaceAll("\\(","\\\\(").replaceAll("\\)","\\\\)")].toList
			} 
			val project=file.project
			project.accept([resource|
				switch(resource){
					IContainer: return true
					IFile case ignoreFile(resource, ignorePatterns): return false
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

	def private boolean ignoreFile(IFile f, List<String> ignorePatterns) {
		if (f.fileExtension == "xarch" || f.name == ".project" || f.name == ".gitignore") {
			return true
		} else if (f.location.removeFileExtension.lastSegment.endsWith("_")) {
			return true
		} else if (!ignorePatterns.empty) {
			val fileLocationWithoutProject = f.fullPath.removeFirstSegments(1).toString
			if (ignorePatterns.exists[p|fileLocationWithoutProject.matches(p) || f.name.matches(p)]) {
				return true
			}
		}
		return false;
	}
}