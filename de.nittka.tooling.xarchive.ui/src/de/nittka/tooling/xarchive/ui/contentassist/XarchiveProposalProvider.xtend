/*******************************************************************************
 * Copyright (C) 2016-2020 Alexander Nittka (alex@nittka.de)
 * 
 * This program and the accompanying materials are made
 * available under the terms of the Eclipse Public License 2.0
 * which is available at https://www.eclipse.org/legal/epl-2.0/
 * 
 * SPDX-License-Identifier: EPL-2.0
 ******************************************************************************/
package de.nittka.tooling.xarchive.ui.contentassist

import de.nittka.tooling.xarchive.ui.XarchiveFileURIs
import de.nittka.tooling.xarchive.xarchive.Document
import java.util.List
import javax.inject.Inject
import org.eclipse.core.resources.IContainer
import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IWorkspace
import org.eclipse.core.runtime.Path
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.Assignment
import org.eclipse.xtext.ui.editor.contentassist.ContentAssistContext
import org.eclipse.xtext.ui.editor.contentassist.ICompletionProposalAcceptor
import de.nittka.tooling.xarchive.ui.search.XarchiveTagCounter

/**
 * see http://www.eclipse.org/Xtext/documentation/latest/xtext.html#contentAssist on how to customize content assistant
 */
class XarchiveProposalProvider extends AbstractXarchiveProposalProvider {

	@Inject
	var IWorkspace workspace
	@Inject
	var XarchiveTagCounter tagCounter;

	override completeDocument_AdditionalFiles(EObject model, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		if(model instanceof Document){
			val doc=model as Document
			val referenced=XarchiveFileURIs.getReferencedResourceURI(doc.file)
			if(referenced!==null){
				val List<String> propose=newArrayList()
				val file=workspace.root.getFile(new Path(referenced.toPlatformString(true)))
				(file.parent as IContainer).members.filter(IFile).forEach[
					val siblingPath=it.fullPath
					if(siblingPath.removeFileExtension.lastSegment.endsWith("_")){
						propose.add(siblingPath.lastSegment)
					}
				]

				val alreadyPresent=doc.additionalFiles.map[XarchiveFileURIs.getReferencedResourceURI(it)].filterNull.map[lastSegment].toList
				propose.removeAll(alreadyPresent)
				propose.forEach[
					acceptor.accept(createCompletionProposal(context))
				]
			}
		}
	}

	override completeDocument_Tags(EObject model, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		val tags=tagCounter.getTags(model.eResource)
		tags.forEach[acceptor.accept(createCompletionProposal(context))]
	}

	override completeTagSearch_Tag(EObject model, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		val tags=tagCounter.getTags(model.eResource)
		tags.forEach[acceptor.accept(createCompletionProposal(context))]
	}
}
