/*******************************************************************************
 * Copyright (C) 2016-2020 Alexander Nittka (alex@nittka.de)
 * 
 * This program and the accompanying materials are made
 * available under the terms of the Eclipse Public License 2.0
 * which is available at https://www.eclipse.org/legal/epl-2.0/
 * 
 * SPDX-License-Identifier: EPL-2.0
 ******************************************************************************/
package de.nittka.tooling.xarchive.ui.outline

import de.nittka.tooling.xarchive.xarchive.Document
import org.eclipse.xtext.ui.editor.outline.IOutlineNode
import org.eclipse.xtext.ui.editor.outline.impl.DefaultOutlineTreeProvider
import de.nittka.tooling.xarchive.xarchive.Category
import de.nittka.tooling.xarchive.xarchive.Search

/**
 * Customization of the default outline structure.
 *
 * see http://www.eclipse.org/Xtext/documentation.html#outline
 */
class XarchiveOutlineTreeProvider extends DefaultOutlineTreeProvider {

	def dispatch boolean isLeaf(Document doc){
		return true;
	}

	def dispatch String text(Document doc){
		val file=doc.file
		return '''«file.fileName».«file.extension»'''.toString
	}

	def dispatch void createChildren(IOutlineNode parentNode, Document doc){
		//NOOP
	}


	def dispatch String text(Category cat){
		return cat.name
	}

	def dispatch boolean isLeaf(Search search){
		return true;
	}

	def dispatch boolean isLeaf(Category category){
		return category.category.empty;
	}

	def dispatch void createChildren(IOutlineNode parentNode, Search search){
		//NOOP
	}

	def dispatch String text(Search search){
		if(search.id!==null){
			search.id
		}else{
			"unnamed search"
		}
	}
}
