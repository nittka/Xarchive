/*
 * generated by Xtext
 */
package de.nittka.tooling.xarchive.ui;

import org.eclipse.ui.plugin.AbstractUIPlugin;
import org.eclipse.xtext.resource.ILocationInFileProvider;
import org.eclipse.xtext.ui.editor.XtextEditor;
import org.eclipse.xtext.ui.editor.folding.IFoldingRegionProvider;
import org.eclipse.xtext.ui.editor.hyperlinking.IHyperlinkHelper;

import de.nittka.tooling.xarchive.ui.folding.XarchiveFoldingRegionProvider;
import de.nittka.tooling.xarchive.ui.linking.XarchiveHyperlinkHelper;
import de.nittka.tooling.xarchive.ui.linking.XarchiveLocationInFileProvider;

/**
 * Use this class to register components to be used within the IDE.
 */
public class XarchiveUiModule extends de.nittka.tooling.xarchive.ui.AbstractXarchiveUiModule {
	public XarchiveUiModule(AbstractUIPlugin plugin) {
		super(plugin);
	}

	@Override
	public com.google.inject.Provider<org.eclipse.xtext.resource.containers.IAllContainersState> provideIAllContainersState() {
		return org.eclipse.xtext.ui.shared.Access.getWorkspaceProjectsState();
	}

	// contributed by org.eclipse.xtext.generator.validation.ValidatorFragment
	@org.eclipse.xtext.service.SingletonBinding(eager=true)
	public Class<? extends de.nittka.tooling.xarchive.validation.XarchiveValidator> bindXarchiveValidator() {
		return de.nittka.tooling.xarchive.ui.validation.XarchiveUIValidator.class;
	}

	public Class<? extends ILocationInFileProvider> bindXarchiveLocationInFileProvider(){
		return XarchiveLocationInFileProvider.class;
	}

	public Class<? extends IHyperlinkHelper> bindXarchiveHyperlinkHelper(){
		return XarchiveHyperlinkHelper.class;
	}

	public Class<? extends IFoldingRegionProvider> bindXarchiveFoldingRegionProvider(){
		return XarchiveFoldingRegionProvider.class;
	}

	public Class<? extends XtextEditor> bindXarchiveXtextEditor(){
		return XarchiveXtextEditor.class;
	}
}