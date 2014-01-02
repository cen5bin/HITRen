package cn.edu.hit.Dao;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

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
		MessageLogic.addMessageToSelf(uid, mid);
		if (gnames.size() == 0) {
			boolean ret = MessageLogic.addMessageToGlobalTimeline(mid);
			if (!ret) {
				LogKit.err("addMessageToGlobalTimeline");
				retData.put(HttpData.SUC, false);
				return false;
			}
			
		}
		else {
			boolean ret = MessageLogic.addMessageToGroups(uid, mid, gnames);
			if (!ret) {
				LogKit.err("addMessageToGroups");
				retData.put(HttpData.SUC, false);
				return false;
			}
		}
		retData.put(HttpData.SUC, true);
		return true;
	}
	
	public static boolean createTimeline(int uid) {
		BasicDBObject obj = new BasicDBObject(TimeLine.UID, uid);
		obj.put(TimeLine.SEQ, 1);
		obj.put(TimeLine.LIST, new ArrayList<Integer>());
		boolean ret = DBController.addObj(TimeLine.COLLNAME, obj);
		if (!ret)
			LogKit.err("createTimeline failed");
		return ret;
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
	
	private static boolean addMessageToGlobalTimeline(int mid) {
		BasicDBObject oldObj = new BasicDBObject(TimeLine.UID, 0);
		BasicDBObject newObj = new BasicDBObject("$push", new BasicDBObject(TimeLine.LIST, mid));
		newObj.put("$inc", new BasicDBObject(TimeLine.SEQ, 1));
		return DBController.update(TimeLine.GLOBAL, oldObj, newObj, true, false);
	}
	
	private static boolean addMessageToGroups(int uid, int mid, ArrayList<String> gnames) throws JSONException {
		Map<String, ArrayList<Integer>> relationShip = RelationshipLogic.getRelationshipOfUser(uid);
		Set<Integer> users = new HashSet<Integer>();
		for (String gname : gnames) {
			users.addAll(relationShip.get(gname));
		}
		return MessageLogic.addMessageToUsers(mid, users);
	}
	
	private static boolean addMessageToUsers(int mid, Collection<Integer> users) {
		BasicDBObject oldObj = new BasicDBObject(TimeLine.UID, new BasicDBObject("$in", users));
		BasicDBObject newObj = new BasicDBObject("$push", new BasicDBObject(TimeLine.LIST, mid));
		newObj.put("$inc", new BasicDBObject(TimeLine.SEQ, 1));
		boolean ret = DBController.update(TimeLine.COLLNAME, oldObj, newObj, false, true);
		if (!ret)
			LogKit.err("addMessageToUsers failed");
		return ret;
	}
	
	private static boolean addMessageToSelf(int uid, int mid) {
		ArrayList<Integer> users = new ArrayList<Integer>();
		users.add(uid);
		return MessageLogic.addMessageToUsers(mid, users);
	}
}
