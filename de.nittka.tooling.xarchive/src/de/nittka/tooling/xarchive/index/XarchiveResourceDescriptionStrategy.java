/*******************************************************************************
 * Copyright (C) 2016-2020 Alexander Nittka (alex@nittka.de)
 * 
 * This program and the accompanying materials are made
 * available under the terms of the Eclipse Public License 2.0
 * which is available at https://www.eclipse.org/legal/epl-2.0/
 * 
 * SPDX-License-Identifier: EPL-2.0
 ******************************************************************************/
package de.nittka.tooling.xarchive.index;

import java.util.HashMap;
import java.util.Map;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.naming.QualifiedName;
import org.eclipse.xtext.resource.EObjectDescription;
import org.eclipse.xtext.resource.IEObjectDescription;
import org.eclipse.xtext.resource.impl.DefaultResourceDescriptionStrategy;
import org.eclipse.xtext.util.IAcceptor;

import com.google.common.base.Joiner;

import de.nittka.tooling.xarchive.xarchive.ArchiveConfig;
import de.nittka.tooling.xarchive.xarchive.Document;

public class XarchiveResourceDescriptionStrategy extends
		DefaultResourceDescriptionStrategy {

	@Override
	public boolean createEObjectDescriptions(EObject eObject,
			IAcceptor<IEObjectDescription> acceptor) {
		if(eObject instanceof Document){
			Document doc=(Document)eObject;
			QualifiedName qualifiedName = getQualifiedNameProvider().getFullyQualifiedName(eObject);
			if(qualifiedName!=null){
				Map<String,String> map=new HashMap<String, String>();
				if(doc.getDocDate()!=null){
					map.put("date", doc.getDocDate());
				}
				if(doc.getReference()!=null){
					map.put("reference", doc.getReference());
				}
				if(doc.getDescription()!=null){
					map.put("desc", doc.getDescription());
				}
				if(!doc.getTags().isEmpty()){
					map.put("tags", Joiner.on(";").join(doc.getTags()));
				}
				acceptor.accept(EObjectDescription.create(qualifiedName, eObject, map));
			}
			return false;
		} else if(eObject instanceof ArchiveConfig){
			acceptor.accept(EObjectDescription.create(QualifiedName.create(eObject.eResource().getURI().lastSegment()), eObject));
			return true;
		} else {
			return super.createEObjectDescriptions(eObject, acceptor);
		}
	}
}
