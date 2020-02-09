/*******************************************************************************
 * Copyright (C) 2016-2020 Alexander Nittka (alex@nittka.de)
 * 
 * This program and the accompanying materials are made
 * available under the terms of the Eclipse Public License 2.0
 * which is available at https://www.eclipse.org/legal/epl-2.0/
 * 
 * SPDX-License-Identifier: EPL-2.0
 ******************************************************************************/
package de.nittka.tooling.xarchive.ui.contentassist;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.eclipse.jface.text.templates.TemplateContext;
import org.eclipse.jface.text.templates.TemplateVariable;
import org.eclipse.xtext.ui.editor.templates.AbstractTemplateVariableResolver;
import org.eclipse.xtext.ui.editor.templates.XtextTemplateContext;
import org.eclipse.xtext.ui.editor.templates.XtextTemplateContextType;

import com.google.common.collect.ImmutableList;

public class XarchiveTemplateContextType extends XtextTemplateContextType {

	private class XarchiveDateVariableResolver extends AbstractTemplateVariableResolver{

		//${date} with format is only available starting with Neon
		//see e.g. https://bugs.eclipse.org/bugs/show_bug.cgi?id=75981
		private SimpleDateFormat format=new SimpleDateFormat("yyyy-MM-dd");
		public XarchiveDateVariableResolver() {
			super("today","inserts today's date in correct format");
		}
		@Override
		public List<String> resolveValues(TemplateVariable variable,
				XtextTemplateContext xtextTemplateContext) {
			return ImmutableList.of(format.format(new Date()));
		}
		@Override
		protected boolean isUnambiguous(TemplateContext context) {
			return true;
		}
	}
	@Override
	protected void addDefaultTemplateVariables() {
		super.addDefaultTemplateVariables();
		addResolver(new XarchiveDateVariableResolver());
	}
}
