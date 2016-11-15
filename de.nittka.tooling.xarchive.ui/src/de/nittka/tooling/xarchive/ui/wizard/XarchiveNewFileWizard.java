package de.nittka.tooling.xarchive.ui.wizard;

import java.util.Iterator;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.NullProgressMonitor;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.jface.wizard.Wizard;
import org.eclipse.ui.IEditorPart;
import org.eclipse.ui.INewWizard;
import org.eclipse.ui.IWorkbench;
import org.eclipse.ui.IWorkbenchPage;
import org.eclipse.ui.PartInitException;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.ide.IDE;
import org.eclipse.xtext.ui.editor.XtextEditor;
import org.eclipse.xtext.util.StringInputStream;

import com.google.common.base.Throwables;

import de.nittka.tooling.xarchive.ui.XarchiveFileURIs;

public class XarchiveNewFileWizard extends Wizard implements INewWizard {

	private IFile file=null;
	private IFile targetFile=null;
	private String errorMessage=": a single file needs to be selected";
	
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
			try {
				String content=file.getName()+"\n";
				targetFile.create(new StringInputStream(content), true, new NullProgressMonitor());
				getShell().getDisplay().asyncExec(new Runnable() {
					public void run() {
						IWorkbenchPage page =
							PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage();
						try {
							IEditorPart editor = IDE.openEditor(page, targetFile, true);
							if(editor instanceof XtextEditor){
								((XtextEditor) editor).selectAndReveal(content.length(), 0);
							}
						} catch (PartInitException e) {
						}
					}
				});
			} catch (CoreException e) {
				Throwables.propagate(e);
			}
		}
		return true;
	}

}