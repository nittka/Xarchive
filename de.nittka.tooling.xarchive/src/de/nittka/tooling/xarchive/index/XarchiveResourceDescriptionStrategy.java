package de.nittka.tooling.xarchive.index;

import java.util.HashMap;
import java.util.Map;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.naming.QualifiedName;
import org.eclipse.xtext.resource.EObjectDescription;
import org.eclipse.xtext.resource.IEObjectDescription;
import org.eclipse.xtext.resource.impl.DefaultResourceDescriptionStrategy;
import org.eclipse.xtext.util.IAcceptor;

import com.google.common.base.Joiner;

import de.nittka.tooling.xarchive.xarchive.Document;

public class XarchiveResourceDescriptionStrategy extends
		DefaultResourceDescriptionStrategy {

	@Override
	public boolean createEObjectDescriptions(EObject eObject,
			IAcceptor<IEObjectDescription> acceptor) {
		if(eObject instanceof Document){
			Document doc=(Document)eObject;
			QualifiedName qualifiedName = getQualifiedNameProvider().getFullyQualifiedName(eObject);
			Map<String,String> map=new HashMap<String, String>();
			if(doc.getDate()!=null){
				map.put("date", doc.getDate());
			}
			if(doc.getDescription()!=null){
				map.put("desc", doc.getDescription());
			}
			if(!doc.getTags().isEmpty()){
				map.put("tags", Joiner.on(";").join(doc.getTags()));
			}
			acceptor.accept(EObjectDescription.create(qualifiedName, eObject, map));
			return false;
		}else{
			return super.createEObjectDescriptions(eObject, acceptor);
		}
	}
}
