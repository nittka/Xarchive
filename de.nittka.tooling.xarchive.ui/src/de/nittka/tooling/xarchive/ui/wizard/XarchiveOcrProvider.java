package de.nittka.tooling.xarchive.ui.wizard;

import org.eclipse.core.resources.IFile;

public interface XarchiveOcrProvider {

	/**
	 * return plain text content of the given file;
	 * 
	 * return null if no usable text can be extracted
	 * */
	String getOCR(IFile file);
}
