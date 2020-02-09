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

import org.eclipse.xtext.resource.IEObjectDescription
import org.eclipse.xtext.ui.label.DefaultDescriptionLabelProvider
import de.nittka.tooling.xarchive.xarchive.XarchivePackage

//import org.eclipse.xtext.resource.IEObjectDescription

/**
 * Provides labels for a IEObjectDescriptions and IResourceDescriptions.
 * 
 * see http://www.eclipse.org/Xtext/documentation/latest/xtext.html#labelProvider
 */
class XarchiveDescriptionLabelProvider extends DefaultDescriptionLabelProvider {

	// Labels and icons can be computed like this:
	
	override text(IEObjectDescription ele) {
		if(ele.EClass===XarchivePackage.Literals.DOCUMENT){
			val desc=ele.getUserData("desc")
			if(desc!==null){
				return '''«ele.name» - «desc»'''.toString
			}
		}
		super.text(ele)
	}

	override image(IEObjectDescription ele) {
		if(ele.EClass===XarchivePackage.Literals.DOCUMENT){
			return 'file_obj.gif'
		}
	}
}
