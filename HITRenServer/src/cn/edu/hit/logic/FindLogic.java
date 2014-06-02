package cn.edu.hit.logic;

import java.util.ArrayList;

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
		addToThingssLine(tid);
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
	
	public static boolean downloadThingsLine(int seq) throws JSONException {
		logger.info("downloadThingsLine");
		retData = new JSONObject();
		BasicDBObject obj1 = new BasicDBObject(ThingsLine.UID, 0);
		int[] range = {0, 10000};
		BasicDBObject obj2 = new BasicDBObject(ThingsLine.LIST, new BasicDBObject("$slice", range));
		DBObject retObj = DBController.queryOne(ThingsLine.COLLNAME, obj1, obj2);
		if (retObj == null) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		retData.put(HttpData.SUC, true);
		int seq0 = Integer.parseInt(retObj.get(ThingsLine.SEQ).toString());
		if (seq == seq0) {
			retData.put(HttpData.INFO, "newest");
			return true;
		}
		JSONObject data = new JSONObject();
		data.put("seq", seq0);
		BasicDBList retList = (BasicDBList) retObj.get(ThingsLine.LIST);
		int len = retList.size();
		if (len > seq0 - seq + 100)
			data.put("tids", retList.subList(0, seq0 - seq + 100));
		else
			data.put("tids", retList);
		logger.info(data);
			retData.put(HttpData.DATA, data);	
		return true;
	}
	
	private static boolean addToThingssLine(int tid) {
		BasicDBObject oldObj = new BasicDBObject(ThingsLine.UID, 0);
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
