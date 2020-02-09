/*******************************************************************************
 * Copyright (C) 2016-2020 Alexander Nittka (alex@nittka.de)
 * 
 * This program and the accompanying materials are made
 * available under the terms of the Eclipse Public License 2.0
 * which is available at https://www.eclipse.org/legal/epl-2.0/
 * 
 * SPDX-License-Identifier: EPL-2.0
 ******************************************************************************/
package de.nittka.tooling.xarchive.ui.folding;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.nodemodel.ICompositeNode;
import org.eclipse.xtext.nodemodel.util.NodeModelUtils;
import org.eclipse.xtext.ui.editor.folding.DefaultFoldingRegionProvider;

import de.nittka.tooling.xarchive.xarchive.CategoryType;
import de.nittka.tooling.xarchive.xarchive.FullTextForSearch;
import de.nittka.tooling.xarchive.xarchive.Search;

public class XarchiveFoldingRegionProvider extends DefaultFoldingRegionProvider {

	@Override
	protected boolean isHandled(EObject eObject) {
		if(eObject instanceof FullTextForSearch){
			return numberOfLines(eObject)>2;
		} else if(eObject instanceof CategoryType){
			return numberOfLines(eObject)>5;
		} else if(eObject instanceof Search){
			return numberOfLines(eObject)>5;
		}
		return false;
	}

	private int numberOfLines(EObject e){
		ICompositeNode node = NodeModelUtils.findActualNodeFor(e);
		if(node!=null){
			return node.getEndLine()-node.getStartLine();
		}else{
			return -1;
		}
	}
}
