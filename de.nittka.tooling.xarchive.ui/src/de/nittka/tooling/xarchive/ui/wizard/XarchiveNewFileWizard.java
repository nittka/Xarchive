/*******************************************************************************
 * Copyright (C) 2016-2020 Alexander Nittka (alex@nittka.de)
 * 
 * This program and the accompanying materials are made
 * available under the terms of the Eclipse Public License 2.0
 * which is available at https://www.eclipse.org/legal/epl-2.0/
 * 
 * SPDX-License-Identifier: EPL-2.0
 ******************************************************************************/
package de.nittka.tooling.xarchive.ui.wizard;

import java.util.Iterator;

import javax.inject.Inject;

import org.eclipse.core.resources.IFile;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.jface.wizard.Wizard;
import org.eclipse.ui.INewWizard;
import org.eclipse.ui.IWorkbench;

import de.nittka.tooling.xarchive.ui.XarchiveFileURIs;

public class XarchiveNewFileWizard extends Wizard implements INewWizard {

	private IFile file=null;
	private IFile targetFile=null;
	private String errorMessage=": a single file needs to be selected";
	@Inject
	private XarchiveNewFileCreator fileCreator;
	
	@Override
	public void init(IWorkbench workbench, IStructuredSelection selection) {
		if(selection!=null && !selection.isEmpty()){
			Iterator<?> iterator = selection.iterator();
			Object first = iterator.next();
			if(first instanceof IFile){
				file=(IFile)first;
			}
			if(iterator.hasNext()){
				file=null;
			}
		}
		if(file!=null){
			if("xarch".equals(file.getFileExtension())){
				file=null;
				errorMessage=": an Xarchive file is selected";
			} else if(file.exists()){
				targetFile=XarchiveFileURIs.getXarchiveFile(file);
				if(targetFile.exists()){
					file=null;
					errorMessage=": Xarchive file already exists";
				}
			}
		}
	}

	@Override
	public boolean performFinish() {
		if(file==null){
			MessageDialog.openError(getShell(), "Xarchive", "Cannot create Xarchive file for the current selection"+errorMessage);
		}else{
			fileCreator.createXarchiveFile(file, getShell());
		}
		return true;
	}
}
