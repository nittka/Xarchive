/*******************************************************************************
 * Copyright (C) 2016-2020 Alexander Nittka (alex@nittka.de)
 * 
 * This program and the accompanying materials are made
 * available under the terms of the Eclipse Public License 2.0
 * which is available at https://www.eclipse.org/legal/epl-2.0/
 * 
 * SPDX-License-Identifier: EPL-2.0
 ******************************************************************************/
package de.nittka.tooling.xarchive.formatting

import de.nittka.tooling.xarchive.services.XarchiveGrammarAccess
import javax.inject.Inject
import org.eclipse.xtext.formatting.impl.AbstractDeclarativeFormatter
import org.eclipse.xtext.formatting.impl.FormattingConfig

/**
 * This class contains custom formatting description.
 * 
 * see : http://www.eclipse.org/Xtext/documentation/latest/xtext.html#formatting
 * on how and when to use it 
 * 
 * Also see {@link org.eclipse.xtext.xtext.XtextFormattingTokenSerializer} as an example
 */
class XarchiveFormatter extends AbstractDeclarativeFormatter {

	@Inject extension XarchiveGrammarAccess
	
	override protected void configureFormatting(FormattingConfig c) {
		//general stuff
		// It's usually a good idea to activate the following three statements.
		// They will add and preserve newlines around comments
		c.setLinewrap(0, 1, 2).before(SL_COMMENTRule)
		c.setLinewrap(0, 1, 2).before(ML_COMMENTRule)
		c.setLinewrap(0, 1, 1).after(ML_COMMENTRule)
		findKeywords(",", ":", ";").forEach[
			c.setNoSpace.before(it)
		]

		//document
//		c.setLinewrap(2).after(documentFileNameRule)
		c.setLinewrap(1, 1, 1).before(documentAccess.namespaceKeyword_2_0)
		c.setLinewrap(1, 1, 1).before(documentAccess.plusSignKeyword_3_0)
		c.setLinewrap(1, 1, 2).before(documentAccess.dateKeyword_4_0_0)
		c.setLinewrap(1, 1, 2).before(documentAccess.referenceKeyword_4_1_0)
		c.setLinewrap(1, 1, 2).before(documentAccess.tagsKeyword_6_0_0)
		c.setLinewrap(1, 1, 2).before(documentAccess.descriptionKeyword_7_0)
		c.setLinewrap(1, 1, 2).before(categoryRefRule)
		c.setLinewrap(1, 1, 2).before(seeAlsoRule)
		c.setLinewrap(1, 1, 2).before(FULLTEXTRule)

		//config
		c.setLinewrap(2).after(categoryTypeAccess.rightCurlyBracketKeyword_6)

		c.setLinewrap(1).around(categoryTypeAccess.categoryAssignment_4)
		c.setLinewrap(1).around(categoryTypeAccess.categoryAssignment_5_1)
		c.setIndentationIncrement.after(categoryTypeAccess.leftCurlyBracketKeyword_3)
		c.setIndentationDecrement.before(categoryTypeAccess.rightCurlyBracketKeyword_6)

		c.setLinewrap(1).around(categoryAccess.categoryAssignment_2_0_1)
		c.setLinewrap(1).around(categoryAccess.categoryAssignment_2_0_2_1)
		c.setIndentationIncrement.after(categoryAccess.leftCurlyBracketKeyword_2_0_0)
		c.setIndentationDecrement.before(categoryAccess.rightCurlyBracketKeyword_2_0_3)

		c.setLinewrap(1).around(categoryAccess.shortCutsAssignment_2_1_2)
		c.setLinewrap(1).around(categoryAccess.shortCutsAssignment_2_1_3_1)
		c.setIndentationIncrement.after(categoryAccess.leftParenthesisKeyword_2_1_1)
		c.setIndentationDecrement.before(categoryAccess.rightParenthesisKeyword_2_1_4)

		//search
		c.setLinewrap(2).before(searchAccess.searchKeyword_0)
		c.setIndentationIncrement.before(searchAccess.searchAssignment_2)
		c.setIndentationDecrement.after(searchAccess.searchAssignment_2)
		c.setLinewrap(1).before(searchAccess.searchAssignment_2)

		c.setIndentationIncrement.before(andSearchExpressionAccess.ampersandAmpersandKeyword_1_1)
		c.setIndentationDecrement.after(andSearchExpressionAccess.ampersandAmpersandKeyword_1_1)
		c.setLinewrap(1).around(andSearchExpressionAccess.ampersandAmpersandKeyword_1_1)

		c.setIndentationIncrement.before(orSearchExpressionAccess.verticalLineVerticalLineKeyword_1_1)
		c.setIndentationDecrement.after(orSearchExpressionAccess.verticalLineVerticalLineKeyword_1_1)
		c.setLinewrap(1).around(orSearchExpressionAccess.verticalLineVerticalLineKeyword_1_1)

		c.setLinewrap(1).around(parenthesizedSearchExpressionAccess.leftParenthesisKeyword_0)
		c.setIndentationIncrement.after(parenthesizedSearchExpressionAccess.leftParenthesisKeyword_0)
		c.setLinewrap(1).before(parenthesizedSearchExpressionAccess.rightParenthesisKeyword_2)
		c.setIndentationDecrement.before(parenthesizedSearchExpressionAccess.rightParenthesisKeyword_2)
	}
}
