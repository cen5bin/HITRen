package cn.edu.hit.logic;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONException;
import org.json.JSONObject;

import cn.edu.hit.constant.EventInfo;
import cn.edu.hit.constant.EventLine;
import cn.edu.hit.constant.HttpData;
import cn.edu.hit.dao.DBController;

import com.mongodb.BasicDBList;
import com.mongodb.BasicDBObject;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

public class EventLogic extends BaseLogic {
	public static boolean uploadEventInfo(int uid, String eid, String time, String place, String desc, ArrayList<Integer> reminds) throws JSONException {
		retData = new JSONObject();
		BasicDBObject oldObj = new BasicDBObject(EventInfo.EID,eid);
		BasicDBObject obj = new BasicDBObject();
		BasicDBObject tmp = new BasicDBObject();
		tmp.put(EventInfo.UID, uid);
		tmp.put(EventInfo.EID, eid);
		tmp.put(EventInfo.TIME, time);
		tmp.put(EventInfo.DESCRIPTION, desc);
		tmp.put(EventInfo.REMINDS, reminds);
		tmp.put(EventInfo.PLACE, place);
//		obj.put("$set", new BasicDBObject(EventInfo.UID, uid));
//		obj.put("$set", new BasicDBObject(EventInfo.EID, eid));
//		obj.put("$set", new BasicDBObject(EventInfo.TIME, time));
//		obj.put("$set", new BasicDBObject(EventInfo.DESCRIPTION, desc));
//		obj.put("$set", new BasicDBObject(EventInfo.REMINDS, reminds));
		obj.put("$set", tmp);
		obj.put("$inc", new BasicDBObject(EventInfo.SEQ, 1));
		boolean ret = DBController.update(EventInfo.COLLNAME, oldObj, obj, true, false);
		if (!ret) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		ret = insertEventLine(uid, eid);
		if (!ret) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		retData.put(HttpData.SUC, true);
		return true;
	}
	
	public static boolean downloadEventLine(int uid, int seq) throws JSONException {
		retData = new JSONObject();
		BasicDBObject obj1 = new BasicDBObject(EventLine.UID, uid);
		int[] range = {0, 10000};
		BasicDBObject obj2 = new BasicDBObject(EventLine.LIST, new BasicDBObject("$slice", range));
		DBObject retObj = DBController.queryOne(EventLine.COLLNAME, obj1, obj2);
		if (retObj == null) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		retData.put(HttpData.SUC, true);
		int seq0 = Integer.parseInt(retObj.get(EventLine.SEQ).toString());
		if (seq == seq0) {
			retData.put(HttpData.INFO, "newest");
			return true;
		}
		JSONObject data = new JSONObject();
		data.put("seq", seq0);
		BasicDBList retList = (BasicDBList) retObj.get(EventLine.LIST);
		int len = retList.size();
		if (len > seq0 - seq + 100)
			data.put("eids", retList.subList(0, seq0 - seq + 100));
		else
			data.put("eids", retList);
			retData.put(HttpData.DATA, data);	
		return true;
	}
	
	public static boolean downloadEventInfos(ArrayList<JSONObject> datas) throws JSONException {
		retData = new JSONObject();
		ArrayList<String> eids = new ArrayList<String>();
		Map<String, Integer> map = new HashMap<String, Integer>();
		for (JSONObject data : datas) {
			eids.add(data.getString("eid"));
			map.put(data.getString("eid"), data.getInt("seq"));
		}
		BasicDBObject obj = new BasicDBObject(EventInfo.EID, new BasicDBObject("$in", eids));
		DBCursor cursor = DBController.query(EventInfo.COLLNAME, obj);
		JSONObject ret = new JSONObject();
		while (cursor.hasNext()) {
			DBObject retObj = cursor.next();
			int seq0 = map.get(retObj.get(EventInfo.EID));
			int seq1 = Integer.parseInt(retObj.get(EventInfo.SEQ).toString());
			if (seq0 >= seq1) continue;
			ret.put(retObj.get(EventInfo.EID).toString(), retObj);
			logger.info(retObj);
		}
		retData.put(HttpData.SUC, true);
		retData.put(HttpData.DATA, ret);
		return true;

	}
	
	private static boolean insertEventLine(int uid, String eid) {
		BasicDBObject oldObj = new BasicDBObject(EventLine.UID, uid);
		BasicDBObject newObj = new BasicDBObject("$push", new BasicDBObject(EventLine.LIST, eid));
		newObj.put("$inc", new BasicDBObject(EventLine.SEQ, 1));
		boolean ret = DBController.update(EventLine.COLLNAME, oldObj, newObj, true, false);
		return ret;
	}
}
