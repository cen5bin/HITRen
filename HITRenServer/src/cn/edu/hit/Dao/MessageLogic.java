package cn.edu.hit.Dao;

import java.util.ArrayList;
import java.util.Map;

import org.json.JSONException;
import org.json.JSONObject;

import cn.edu.hit.kit.LogKit;
import cn.edu.hit.kit.TimeKit;

import com.mongodb.BasicDBObject;
import com.mongodb.DBObject;

public class MessageLogic {
	public static JSONObject retData;
	
	public static boolean sendShortMessage(int uid, String message, ArrayList<String> gnames) throws JSONException {
		retData = new JSONObject();
		int mid = createMid();
		if (mid == -1) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		String now = TimeKit.now();
		int type = Message.Type.NORMAL;
		BasicDBObject obj = new BasicDBObject();
		obj.put(Message.MID, mid);
		obj.put(Message.UID, uid);
		obj.put(Message.TIME, now);
		obj.put(Message.COMMENTLIST, new ArrayList<String>());
		obj.put(Message.LIKEDLIST, new ArrayList<String>());
		obj.put(Message.SHATECOUNT, 0);
		obj.put(Message.TYPE, type);
		obj.put(Message.CONTENT, message);
		DBController.addObj(Message.COLLNAME, obj);
//		if (gnames.size() == 0)
		return true;
	}
	
	private static int createMid() {
		BasicDBObject oldObj = new BasicDBObject(IDCounter.KEY, IDCounter.MID);
		BasicDBObject newObj = new BasicDBObject("$inc", new BasicDBObject().append(IDCounter.VALUE, 1));
		boolean ret = DBController.update(IDCounter.COLLNAME, oldObj, newObj, true, false);
		if (!ret) {
			LogKit.err("createMid");
			return -1;
		}
		DBObject retObj = DBController.queryOne(IDCounter.COLLNAME, oldObj);
		return (Integer) retObj.get(IDCounter.VALUE);
	}
	
	private static boolean sendShortMessage(int uid, String message) throws JSONException {
		retData = new JSONObject();
		Map<String, ArrayList<Integer>> relationShip = RelationshipLogic.getRelationshipOfUser(uid);
		ArrayList<Integer> defaultGroup = relationShip.get("default");
		return true;
	}
}
