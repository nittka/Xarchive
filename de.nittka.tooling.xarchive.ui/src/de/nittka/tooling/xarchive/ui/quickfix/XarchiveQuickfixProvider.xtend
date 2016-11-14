/*
* generated by Xtext
*/
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

/**
 * Custom quickfixes.
 *
 * see http://www.eclipse.org/Xtext/documentation.html#quickfixes
 */
class XarchiveQuickfixProvider extends DefaultQuickfixProvider {

	@Fix(XarchiveValidator::FILE_NAME)
	def changeReferencedName(Issue issue, IssueResolutionAcceptor acceptor) {
		val orig=issue.data.get(0)
		val expected=issue.data.get(1)
		acceptor.accept(issue, 'Change file name', 'renames the file to '+orig, null) [
			context |
			val xtextDocument = context.xtextDocument
			val file=xtextDocument.getAdapter(IFile)
			val renamePath=file.projectRelativePath.removeLastSegments(1).append(orig+".xarch")
			file.move(renamePath, true,  new NullProgressMonitor);
		]
		acceptor.accept(issue, 'Change referenced file', 'change referenced file to '+expected, null) [
			obj, context |
			val doc=obj as Document
			doc.file.setFileName(expected)
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
}
