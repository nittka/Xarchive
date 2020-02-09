/*******************************************************************************
 * Copyright (C) 2016-2020 Alexander Nittka (alex@nittka.de)
 * 
 * This program and the accompanying materials are made
 * available under the terms of the Eclipse Public License 2.0
 * which is available at https://www.eclipse.org/legal/epl-2.0/
 * 
 * SPDX-License-Identifier: EPL-2.0
 ******************************************************************************/
package de.nittka.tooling.xarchive.ui.labeling

import com.google.inject.Inject
import de.nittka.tooling.xarchive.xarchive.Category
import de.nittka.tooling.xarchive.xarchive.Document
import org.eclipse.emf.edit.ui.provider.AdapterFactoryLabelProvider
import org.eclipse.xtext.ui.label.DefaultEObjectLabelProvider
import de.nittka.tooling.xarchive.xarchive.Search
import de.nittka.tooling.xarchive.xarchive.CategoryType
import de.nittka.tooling.xarchive.xarchive.ArchiveConfig

/**
 * Provides labels for a EObjects.
 * 
 * see http://www.eclipse.org/Xtext/documentation/latest/xtext.html#labelProvider
 */
class XarchiveLabelProvider extends DefaultEObjectLabelProvider {

	@Inject
	new(AdapterFactoryLabelProvider delegate) {
		super(delegate);
	}

	// Labels and icons can be computed like this:

	def String text(Document doc){
		if(doc.description!==null)'''«doc.file.fileName» - «doc.description»'''else doc?.file?.fileName
	}

	def String text(Category cat){
		val desc=cat.description
		val result=if(desc!==null)'''«cat.name» («desc»)'''else cat.name
		if(cat.eContainer instanceof Category){
			return '''«result» <- «text(cat.eContainer as Category)»'''
		}else{
			return result;
		}
	}

	def image(ArchiveConfig ele) {
		'prop_ps.gif'
	}

	def image(Document ele) {
		'file_obj.gif'
	}

	def image(Category ele) {
		'tree_mode.gif'
	}

	def image(CategoryType ele) {
		'tree_mode.gif'
	}

	def image(Search ele) {
		'insp_sbook.gif'
	}
}
