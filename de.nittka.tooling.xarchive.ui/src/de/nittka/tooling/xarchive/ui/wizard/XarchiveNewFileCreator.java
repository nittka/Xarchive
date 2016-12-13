package de.nittka.tooling.xarchive.ui.wizard;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.NullProgressMonitor;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.ui.IEditorPart;
import org.eclipse.ui.IWorkbenchPage;
import org.eclipse.ui.PartInitException;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.ide.IDE;
import org.eclipse.xtext.ui.editor.XtextEditor;
import org.eclipse.xtext.util.StringInputStream;

import com.google.common.base.Throwables;

import de.nittka.tooling.xarchive.ui.XarchiveFileURIs;

public class XarchiveNewFileCreator {

	public void createXarchiveFile(IFile file, Shell nullableShell){
		IFile targetFile = XarchiveFileURIs.getXarchiveFile(file);
		String prefix=file.getName()+"\n";
		if(!targetFile.exists()){
			try {
				targetFile.create(new StringInputStream(prefix), true, new NullProgressMonitor());
			} catch (CoreException e) {
				Throwables.propagate(e);
			}
		}
		if(nullableShell!=null){
			nullableShell.getDisplay().asyncExec(new Runnable() {
				public void run() {
					IWorkbenchPage page =
							PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage();
					try {
						IEditorPart editor = IDE.openEditor(page, targetFile, true);
						if(editor instanceof XtextEditor){
							((XtextEditor) editor).selectAndReveal(prefix.length(), 0);
						}
					} catch (PartInitException e) {
						//don't care; user can open file later
					}
				}
			});
		}
	}
}