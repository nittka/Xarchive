package de.nittka.tooling.xarchive.ui.wizard;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IConfigurationElement;
import org.eclipse.core.runtime.NullProgressMonitor;
import org.eclipse.core.runtime.Platform;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.ui.IEditorPart;
import org.eclipse.ui.IWorkbenchPage;
import org.eclipse.ui.PartInitException;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.ide.IDE;
import org.eclipse.xtext.ui.editor.XtextEditor;
import org.eclipse.xtext.util.StringInputStream;

import com.google.common.base.Strings;
import com.google.common.base.Throwables;

import de.nittka.tooling.xarchive.ui.XarchiveFileURIs;

public class XarchiveNewFileCreator {

	public void createXarchiveFile(IFile file, Shell nullableShell){
		IFile targetFile = XarchiveFileURIs.getXarchiveFile(file);
		String prefix=file.getName()+"\n";
		if(!targetFile.exists()){
			String ocrString="";
			try{
				XarchiveOcrProvider ocrProvider=getOcrProvider(nullableShell);
				if(ocrProvider!=null){
					ocrString=ocrProvider.getOCR(file);
					if(!Strings.isNullOrEmpty(ocrString)){
						ocrString="\n\n'''\n"+ocrString+"\n'''";
					}
				}
			}catch(Exception e){
				ocrString="";
				//don't care; OCR string not that important
			}
			try {
				targetFile.create(new StringInputStream(prefix+Strings.nullToEmpty(ocrString)), true, new NullProgressMonitor());
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

	private XarchiveOcrProvider getOcrProvider(Shell nullableShell) throws CoreException{
		IConfigurationElement[] configs = Platform.getExtensionRegistry().getConfigurationElementsFor("de.nittka.tooling.xarchive.ui.ocrprovider");
		XarchiveOcrProvider result=null;
		for (IConfigurationElement config : configs) {
			XarchiveOcrProvider provider = (XarchiveOcrProvider)config.createExecutableExtension("class");
			if(result==null){
				result=provider;
			}else {
				if(nullableShell!=null){
					MessageDialog.openError(nullableShell, "Xarchive", "more than one OCR provider present - using the first one");
				}
				break;
			}
		}
		return result;
	}
}