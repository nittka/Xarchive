package de.nittka.tooling.xarchive.ui.search;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.inject.Inject;

import org.eclipse.core.commands.AbstractHandler;
import org.eclipse.core.commands.ExecutionEvent;
import org.eclipse.core.commands.ExecutionException;
import org.eclipse.xtext.resource.IContainer;
import org.eclipse.xtext.resource.IContainer.Manager;
import org.eclipse.xtext.resource.IEObjectDescription;
import org.eclipse.xtext.resource.IResourceDescriptions;
import org.eclipse.xtext.resource.IResourceServiceProvider;
import org.eclipse.xtext.resource.XtextResource;
import org.eclipse.xtext.resource.impl.ResourceDescriptionsProvider;
import org.eclipse.xtext.ui.editor.XtextEditor;
import org.eclipse.xtext.ui.editor.copyqualifiedname.ClipboardUtil;
import org.eclipse.xtext.ui.editor.utils.EditorUtils;
import org.eclipse.xtext.util.concurrent.IUnitOfWork;

import com.google.common.base.Joiner;
import com.google.common.base.Splitter;

import de.nittka.tooling.xarchive.xarchive.XarchivePackage;

public class XarchiveUsedTagsHandler  extends AbstractHandler{

	@Inject
	private ResourceDescriptionsProvider indexProvider;
	@Inject
	private IResourceServiceProvider serviceProvider;

	@Override
	public Object execute(ExecutionEvent event) throws ExecutionException {
		try {
			XtextEditor editor = EditorUtils.getActiveXtextEditor(event);
			if (editor != null) {
				editor.getDocument().readOnly(new IUnitOfWork.Void<XtextResource>() {
					@Override
					public void process(XtextResource state) throws Exception {
						Set<String> tags=new HashSet<>();
						IResourceDescriptions index = indexProvider.getResourceDescriptions(state);
						Manager containerManager = serviceProvider.getContainerManager();

						List<IContainer> visibleContainer = containerManager.getVisibleContainers(serviceProvider.getResourceDescriptionManager().getResourceDescription(state), index);
						for (IContainer container : visibleContainer) {
							for (IEObjectDescription desc : container.getExportedObjectsByType(XarchivePackage.Literals.DOCUMENT)) {
								String optTags = desc.getUserData("tags");
								if(optTags!=null){
									for (String tag : Splitter.on(";").trimResults().split(optTags)) {
										tags.add(tag);
									}
								}
							};
						}
						List<String>sortedTags=new ArrayList<>(tags);
						Collections.sort(sortedTags);
						ClipboardUtil.copy(Joiner.on("\n").skipNulls().join(sortedTags));
					}
				});
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

}
