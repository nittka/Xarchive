/*******************************************************************************
 * Copyright (C) 2016-2020 Alexander Nittka (alex@nittka.de)
 * 
 * This program and the accompanying materials are made
 * available under the terms of the Eclipse Public License 2.0
 * which is available at https://www.eclipse.org/legal/epl-2.0/
 * 
 * SPDX-License-Identifier: EPL-2.0
 ******************************************************************************/
package de.nittka.tooling.xarchive.ui;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.eclipse.jface.text.Position;
import org.eclipse.jface.text.source.Annotation;
import org.eclipse.jface.text.source.projection.ProjectionAnnotation;
import org.eclipse.jface.text.source.projection.ProjectionAnnotationModel;
import org.eclipse.jface.text.source.projection.ProjectionViewer;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.xtext.ui.editor.XtextEditor;
import org.eclipse.xtext.ui.editor.folding.FoldedPosition;


public class XarchiveXtextEditor extends XtextEditor {

	@Override
	public void createPartControl(Composite parent) {
		super.createPartControl(parent);
		ProjectionAnnotationModel model = ((ProjectionViewer) getSourceViewer()).getProjectionAnnotationModel();
		foldRegionsOnStartup(model);
	}

	private void foldRegionsOnStartup(ProjectionAnnotationModel model){
		List<Annotation> changes=new ArrayList<Annotation>(); 
		Iterator<?> iterator = model.getAnnotationIterator();
		while (iterator.hasNext()){
			Object next = iterator.next();
			if(next instanceof ProjectionAnnotation){
				ProjectionAnnotation pa = (ProjectionAnnotation) next;
				Position position = model.getPosition(pa);
				if(position instanceof FoldedPosition){
					pa.markCollapsed();
					changes.add(pa);
				}
			}
		}
		model.modifyAnnotations(null,null, changes.toArray(new Annotation[0]));
	}
}
