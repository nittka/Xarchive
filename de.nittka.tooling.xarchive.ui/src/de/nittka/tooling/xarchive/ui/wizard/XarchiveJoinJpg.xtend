package de.nittka.tooling.xarchive.ui.wizard

import java.util.List
import org.eclipse.core.commands.AbstractHandler
import org.eclipse.core.commands.ExecutionEvent
import org.eclipse.core.commands.ExecutionException
import org.eclipse.core.resources.IFile
import org.eclipse.core.runtime.NullProgressMonitor
import org.eclipse.core.runtime.Path
import org.eclipse.jface.viewers.StructuredSelection
import org.eclipse.ui.PlatformUI
import org.eclipse.xtext.util.StringInputStream

class XarchiveJoinJpg extends AbstractHandler {

	override isEnabled() {
		true
	}
	
	override execute(ExecutionEvent event) throws ExecutionException {
		println(event.parameters)
		val currentSelection=PlatformUI?.getWorkbench()?.activeWorkbenchWindow?.activePage?.selection
		if(currentSelection instanceof StructuredSelection){
			val selection=(currentSelection as StructuredSelection).iterator.toList
			val files=selection
				.filter(IFile)
				.filter[#["jpg","jpeg"].contains(fileExtension.toLowerCase)]
				.sortBy[name]
				.toList
			if(files.map[parent].toSet.size==1){
				val first=files.get(0)
				val texFile=first.parent.getFile(new Path(first.fullPath.removeFileExtension.addFileExtension("tex").lastSegment))
				if(!texFile.exists){
					texFile.create(new StringInputStream(texContent(files)), true, new NullProgressMonitor)
				}
			}
		}
		return null
	}

	def private String texContent(List<IFile> files)'''
		\documentclass[11pt,a4paper]{scrartcl}
		\usepackage{ngerman}
		\usepackage[lmargin=0cm, tmargin=0cm,rmargin=0cm, bmargin=0cm]{geometry}
		\usepackage{graphicx}
		
		\pagestyle{empty}
		\parindent0cm
		
		\newif\ifpdf
		\ifx\pdfoutput\undefined\pdffalse\else\pdfoutput=1\pdftrue\fi
		
		\begin{document}
		\ifpdf
		%\includegraphics[angle=180,width=21cm]{file.jpg}\pagebreak
		«FOR file:files»
		\includegraphics[width=21cm]{«file.name»}\pagebreak
		
		«ENDFOR»
		\fi 
		\end{document}
	'''
}