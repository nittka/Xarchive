/*******************************************************************************
 * Copyright (C) 2016-2020 Alexander Nittka (alex@nittka.de)
 * 
 * This program and the accompanying materials are made
 * available under the terms of the Eclipse Public License 2.0
 * which is available at https://www.eclipse.org/legal/epl-2.0/
 * 
 * SPDX-License-Identifier: EPL-2.0
 ******************************************************************************/
package de.nittka.tooling.xarchive.scoping;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.naming.QualifiedName;
import org.eclipse.xtext.naming.SimpleNameProvider;

import de.nittka.tooling.xarchive.xarchive.Document;

public class XarchiveNameProvider extends SimpleNameProvider {

	@Override
	public QualifiedName getFullyQualifiedName(EObject obj) {
		if(obj instanceof Document){
			Document doc=(Document)obj;
			if(doc.getFile()!=null){
				if(doc.getNamespace()!=null){
					return QualifiedName.create(doc.getNamespace(), doc.getFile().getFileName());
				}else{
					return QualifiedName.create(doc.getFile().getFileName());
				}
			}
		}
		return super.getFullyQualifiedName(obj);
	}
}
