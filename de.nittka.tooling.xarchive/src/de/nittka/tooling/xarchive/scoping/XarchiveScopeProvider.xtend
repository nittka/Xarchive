/*******************************************************************************
 * Copyright (C) 2016-2020 Alexander Nittka (alex@nittka.de)
 * 
 * This program and the accompanying materials are made
 * available under the terms of the Eclipse Public License 2.0
 * which is available at https://www.eclipse.org/legal/epl-2.0/
 * 
 * SPDX-License-Identifier: EPL-2.0
 ******************************************************************************/
package de.nittka.tooling.xarchive.scoping

import de.nittka.tooling.xarchive.xarchive.ArchiveConfig
import de.nittka.tooling.xarchive.xarchive.Category
import de.nittka.tooling.xarchive.xarchive.CategoryRef
import de.nittka.tooling.xarchive.xarchive.ShortCut
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.scoping.Scopes
import org.eclipse.xtext.scoping.impl.AbstractDeclarativeScopeProvider

/**
 * This class contains custom scoping description.
 * 
 * see : http://www.eclipse.org/Xtext/documentation/latest/xtext.html#scoping
 * on how and when to use it 
 *
 */
class XarchiveScopeProvider extends AbstractDeclarativeScopeProvider {

	def IScope scope_CategoryRef_categories(CategoryRef context, EReference ref){
		return Scopes.scopeFor(EcoreUtil2.getAllContentsOfType(context.type, Category));
	}

	def IScope scope_ShortCut_category(ShortCut context, EReference ref){
		return Scopes.scopeFor(EcoreUtil2.getAllContentsOfType(context.type, Category));
	}

	def IScope scope_SearchReference_search(ArchiveConfig context, EReference ref){
		return Scopes.scopeFor(context.searches.filter[id!==null], [QualifiedName.create(id)], IScope.NULLSCOPE);
	}
}
