package cn.edu.hit.logic;

import java.util.ArrayList;
import java.util.regex.Pattern;

import org.json.JSONException;
import org.json.JSONObject;

import cn.edu.hit.constant.HttpData;
import cn.edu.hit.constant.IDCounter;
import cn.edu.hit.constant.Thing;
import cn.edu.hit.constant.ThingsLine;
import cn.edu.hit.dao.DBController;
import cn.edu.hit.kit.TimeKit;

import com.mongodb.BasicDBList;
import com.mongodb.BasicDBObject;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

public class FindLogic extends BaseLogic{
	
	
	
	public static boolean uploadThingsInfo(int uid, String name, ArrayList<String> pics, String desc) throws JSONException {
		retData = new JSONObject();
		BasicDBObject obj = new BasicDBObject();
		int tid = createTid();
		obj.put(Thing.TID, tid);
		obj.put(Thing.NAME, name);
		obj.put(Thing.PICS, pics);
		obj.put(Thing.DESCRIPTION, desc);
		obj.put(Thing.UID, uid);
		obj.put(Thing.TIME, TimeKit.now());
		if (!DBController.addObj(Thing.COLLNAME, obj)) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		addToThingssLine(0, tid);
		addToThingssLine(uid, tid);
		retData.put(HttpData.SUC, true);
		return true;
	}
	
	public static boolean downloadThingsInfo(ArrayList<Integer> tids) throws JSONException {
		retData = new JSONObject();
		BasicDBObject obj = new BasicDBObject(Thing.TID, new BasicDBObject("$in", tids));
		DBCursor cursor = DBController.query(Thing.COLLNAME, obj);
		JSONObject ret = new JSONObject();
		while (cursor.hasNext()) {
			DBObject retObj = cursor.next();
			ret.put(retObj.get(Thing.TID).toString(), retObj);
		}
		retData.put(HttpData.SUC, true);
		retData.put(HttpData.DATA, ret);
		return true;
	}
	
	public static JSONObject downloadThingsLine(int seq) throws JSONException {
		return downloadMyThingsLine(0, seq);
	}
	
	public static JSONObject downloadMyThingsLine(int uid, int seq) throws JSONException {
		JSONObject retJsonObject = new JSONObject();
		BasicDBObject obj1 = new BasicDBObject(ThingsLine.UID, uid);
		int[] range = {0, 10000};
		BasicDBObject obj2 = new BasicDBObject(ThingsLine.LIST, new BasicDBObject("$slice", range));
		DBObject retObj = DBController.queryOne(ThingsLine.COLLNAME, obj1, obj2);
		if (retObj == null) {
			retJsonObject.put(HttpData.SUC, false);
			return retJsonObject;
		}
		retJsonObject.put(HttpData.SUC, true);
		int seq0 = Integer.parseInt(retObj.get(ThingsLine.SEQ).toString());
		if (seq == seq0) {
			retJsonObject.put(HttpData.INFO, "newest");
			return retJsonObject;
		}
		JSONObject data = new JSONObject();
		data.put("seq", seq0);
		BasicDBList retList = (BasicDBList) retObj.get(ThingsLine.LIST);
		data.put("tids", retList);
		retJsonObject.put(HttpData.DATA, data);	
		return retJsonObject;
	}
	
	public static JSONObject searchThings(String info) throws JSONException {
		JSONObject retJsonObject = new JSONObject();
		BasicDBObject obj1 = new BasicDBObject();
		String string = String.format("^.*%s.*$", info);
		Pattern pattern = Pattern.compile(string, Pattern.CASE_INSENSITIVE);
		ArrayList<BasicDBObject> cond = new ArrayList<BasicDBObject>();
		cond.add(new BasicDBObject(Thing.NAME, pattern));
		cond.add(new BasicDBObject(Thing.DESCRIPTION, pattern));
		
		obj1.put("$or", cond);
		DBCursor cursor = DBController.query(Thing.COLLNAME, obj1);
		ArrayList<Integer> tids = new ArrayList<Integer>();
		while (cursor.hasNext()) {
			DBObject retObj = cursor.next();
			tids.add(Integer.parseInt(retObj.get(Thing.TID).toString()));
		}
		retJsonObject.put(HttpData.SUC, true);
		JSONObject data = new JSONObject();
		data.put("tids", tids);
		retJsonObject.put(HttpData.DATA, data);
		return retJsonObject;
	}
	
	private static boolean deleteThingInThingsLine(int uid, int tid) {
		BasicDBObject oldObj = new BasicDBObject(ThingsLine.UID, uid);
		BasicDBObject newObj = new BasicDBObject("$pull", new BasicDBObject(ThingsLine.LIST, tid));
		newObj.put("$inc", new BasicDBObject(ThingsLine.SEQ, 1));
		return DBController.update(ThingsLine.COLLNAME, oldObj, newObj);
	}
	public static JSONObject deleteThing(int uid, int tid) throws JSONException {
		JSONObject retJsonObject = new JSONObject();
		if (deleteThingInThingsLine(0, tid) && deleteThingInThingsLine(uid, tid))
			retJsonObject.put(HttpData.SUC, true);
		retJsonObject.put(HttpData.SUC, false);
		return retJsonObject;
	}
	
	private static boolean addToThingssLine(int uid, int tid) {
		BasicDBObject oldObj = new BasicDBObject(ThingsLine.UID, uid);
		BasicDBObject newObj = new BasicDBObject();
		newObj.put("$push", new BasicDBObject(ThingsLine.LIST, tid));
		newObj.put("$inc", new BasicDBObject(ThingsLine.SEQ, 1));
		DBController.update(ThingsLine.COLLNAME, oldObj, newObj, true, false);
		return true;
	}
	
	private static int createTid() {
		BasicDBObject oldObj = new BasicDBObject();
		oldObj.put(IDCounter.KEY, IDCounter.TID);
		BasicDBObject newObj = new BasicDBObject();
		newObj.put("$inc", new BasicDBObject().append(IDCounter.VALUE, 1));
		if (!DBController.update(IDCounter.COLLNAME, oldObj, newObj, true, false))
			return -1;
		DBCursor cursor = DBController.query(IDCounter.COLLNAME, oldObj);
		if (!cursor.hasNext())
			return -1;
		return (Integer) cursor.next().get(IDCounter.VALUE);
	}
}
