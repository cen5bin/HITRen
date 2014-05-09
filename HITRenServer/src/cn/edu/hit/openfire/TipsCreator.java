package cn.edu.hit.openfire;

import org.json.JSONException;
import org.json.JSONObject;

import cn.edu.hit.dao.DataManager;

enum SNSPushMessageType {
	LIKED,
	COMMENTED,
	SHARED,
	REPORTED
}

class SNSPushMessageField {
	protected final static String TYPE = "type";
	protected final static String MESSAGE = "message";
	protected final static String BY = "by";
	protected final static String BY_UID = "uid";
	protected final static String BY_NAME = "name";
	protected final static String BY_PIC = "pic";
	
}

class PushMessageField {
	protected final static String TYPE = "type";
	protected final static String CONTRNT = "content";
}

public class TipsCreator {
	
	
	protected static String createSNSPushMessage(SNSPushMessageType type, int uid, String name) throws JSONException {
		return createSNSPushMessage(type, uid, name, "", -1);
	}
	
	protected static String createSNSPushMessage(SNSPushMessageType type, int uid, String name, String pic, int mid) throws JSONException {
		JSONObject retObj = new JSONObject();
		int type0 = 0;
		if (type == SNSPushMessageType.LIKED)
			type0 = 1;
		else if (type == SNSPushMessageType.COMMENTED)
			type0 = 2;
		else if (type == SNSPushMessageType.SHARED)
			type0 = 3;
		else if (type == SNSPushMessageType.REPORTED)
			type0 = 4;
		retObj.put(SNSPushMessageField.TYPE, type0);
		retObj.put(SNSPushMessageField.MESSAGE, DataManager.getMessage(mid, true));
		JSONObject by = new JSONObject();
		by.put(SNSPushMessageField.BY_UID, uid);
		by.put(SNSPushMessageField.BY_NAME, name);
		by.put(SNSPushMessageField.BY_PIC, pic);
		retObj.put(SNSPushMessageField.BY, by);
		JSONObject json = new JSONObject();
		json.put(PushMessageField.TYPE, 1);
		json.put(PushMessageField.CONTRNT, retObj);
		return json.toString();
	}
	
	
}

