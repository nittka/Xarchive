/*******************************************************************************
 * Copyright (C) 2016-2020 Alexander Nittka (alex@nittka.de)
 * 
 * This program and the accompanying materials are made
 * available under the terms of the Eclipse Public License 2.0
 * which is available at https://www.eclipse.org/legal/epl-2.0/
 * 
 * SPDX-License-Identifier: EPL-2.0
 ******************************************************************************/
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
		return !selectedJoinableFiles.empty
	}

	override execute(ExecutionEvent event) throws ExecutionException {
		val files=selectedJoinableFiles
		val first=files.get(0)
		val texFile=first.parent.getFile(new Path(first.fullPath.removeFileExtension.addFileExtension("tex").lastSegment))
		if(!texFile.exists){
			val sorted=files.sortBy[name]
			texFile.create(new StringInputStream(texContent(sorted)), true, new NullProgressMonitor)
		}
		return null
	}

	def private List<IFile> getSelectedJoinableFiles(){
		val currentSelection=PlatformUI?.getWorkbench()?.activeWorkbenchWindow?.activePage?.selection
		if(currentSelection instanceof StructuredSelection){
			val selection=(currentSelection as StructuredSelection).iterator.toList
			val files=selection
				.filter(IFile)
				.filter[#["jpg","jpeg"].contains(fileExtension.toLowerCase)]
				.toList
			if(selection.size==files.size && files.size>1 && files.map[parent].toSet.size==1){
				return files
			}
		}
		return #[]
	}

	def private String texContent(List<IFile> files){
		val width=System.getProperty("xarchiveJoinJpgWidth","21cm")
		'''
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
		\includegraphics[width=«width»]{«file.name»}\pagebreak
		
		«ENDFOR»
		\fi 
		\end{document}
		'''
	}
}