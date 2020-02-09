/*******************************************************************************
 * Copyright (C) 2016-2020 Alexander Nittka (alex@nittka.de)
 * 
 * This program and the accompanying materials are made
 * available under the terms of the Eclipse Public License 2.0
 * which is available at https://www.eclipse.org/legal/epl-2.0/
 * 
 * SPDX-License-Identifier: EPL-2.0
 ******************************************************************************/
package de.nittka.tooling.xarchive.ui.quickfix

import de.nittka.tooling.xarchive.validation.XarchiveValidator
import de.nittka.tooling.xarchive.xarchive.Document
import de.nittka.tooling.xarchive.xarchive.XarchivePackage
import org.eclipse.core.resources.IFile
import org.eclipse.core.runtime.NullProgressMonitor
import org.eclipse.xtext.nodemodel.util.NodeModelUtils
import org.eclipse.xtext.ui.editor.quickfix.DefaultQuickfixProvider
import org.eclipse.xtext.ui.editor.quickfix.Fix
import org.eclipse.xtext.ui.editor.quickfix.IssueResolutionAcceptor
import org.eclipse.xtext.validation.Issue
import de.nittka.tooling.xarchive.ui.wizard.XarchiveNewFileCreator
import javax.inject.Inject
import de.nittka.tooling.xarchive.ui.validation.XarchiveUIValidator
import org.eclipse.core.runtime.Path
import org.eclipse.swt.widgets.Shell
import org.eclipse.ui.PlatformUI
import de.nittka.tooling.xarchive.xarchive.DocumentFileName

/**
 * Custom quickfixes.
 *
 * see http://www.eclipse.org/Xtext/documentation.html#quickfixes
 */
class XarchiveQuickfixProvider extends DefaultQuickfixProvider {

	@Inject
	XarchiveNewFileCreator fileCreator

	@Fix(XarchiveValidator::FILE_NAME)
	def changeReferencedName(Issue issue, IssueResolutionAcceptor acceptor) {
		val orig=issue.data.get(0)
		val expected=issue.data.get(1)
		acceptor.accept(issue, 'Change file name', 'renames the file to '+orig, null) [
			context |
			val xtextDocument = context.xtextDocument
			val file=xtextDocument.getAdapter(IFile)
			val renamePath=file.fullPath.removeLastSegments(1).append(orig+".xarch")
			file.move(renamePath, true,  new NullProgressMonitor);
		]
		acceptor.accept(issue, 'Change referenced file', 'change referenced file to '+expected, null) [
			obj, context |
			val file=obj as DocumentFileName
			file.setFileName(expected)
		]
	}

	@Fix(XarchiveValidator::MISSING_CATEGORY)
	def addMissingCategory(Issue issue, IssueResolutionAcceptor acceptor) {
		val category=issue.data.get(0)
		acceptor.accept(issue, 'add category', 'add category '+category, null) [
			obj, context |
			val xtextDocument=context.xtextDocument
			val doc=obj as Document
			val offset=NodeModelUtils.findNodesForFeature(doc, XarchivePackage.Literals.DOCUMENT__CATEGORIES).get(0).offset
			xtextDocument.replace(offset, 0, category+": ;\n")
		]
	}

	@Fix(XarchiveUIValidator::MISSING_XARCHIVE_FILE)
	def addMissingXarchive(Issue issue, IssueResolutionAcceptor acceptor) {
		val displayName=issue.data.get(0)
		val fullPath=issue.data.get(1)
		acceptor.accept(issue, 'Xarchive for '+displayName, 'creates a new Xarchive file', null) [
			obj, context |
			val file=context.xtextDocument.getAdapter(IFile)
			val target=file.workspace.root.getFile(new Path(fullPath))
			val Shell shell =try{
				PlatformUI.workbench.activeWorkbenchWindow.shell
			}catch(Exception e){
				null
			}
			fileCreator.createXarchiveFile(target, shell)
		]
	}
}
