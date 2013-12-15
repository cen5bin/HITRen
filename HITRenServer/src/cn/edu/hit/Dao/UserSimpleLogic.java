package cn.edu.hit.Dao;


import org.json.JSONException;
import org.json.JSONObject;

import com.mongodb.BasicDBObject;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;


public class UserSimpleLogic {
	
	//登录功能的
	public static boolean login(String email, String password) throws JSONException {
		BasicDBObject obj = new BasicDBObject();
		retData = new JSONObject();
		obj.put(UserConstant.EMAIL, email);
		obj.put(UserConstant.PASSWORD, password);
		DBCursor cursor = DBController.query(UserConstant.COLLNAME, obj);
		if (!cursor.hasNext()) {
			retData.put("SUC", false);
			return false;
		}
		retData.put("SUC", true);
		retData.put("uid", cursor.next().get(IDCounter.UID).toString());
		return true;
	}
	
	//注册功能
	public static boolean register(String email, String password) throws JSONException {
		BasicDBObject obj = new BasicDBObject();
		retData = new JSONObject();
		obj.put(UserConstant.EMAIL, email);
		if (DBController.objExits(UserConstant.COLLNAME, obj)) {
			retData.put("SUC", false);
			return false;
		}
		obj.put(UserConstant.PASSWORD, password);
		int uid = UserSimpleLogic.createUid();
		System.out.println(uid);
		if (uid == -1) {
			retData.put("SUC", false);
			return false;
		}
		obj.put(UserConstant.UID, uid);
		obj.put("seq", 1);
		retString = "" + uid;
		if (!DBController.addObj(UserConstant.COLLNAME, obj)) {
			retData.put("SUC", false);
			return false;
		}
		retData.put("SUC", true);
		retData.put("uid", uid);
		retData.put("seq", 1);
		return true;
	}
	
	//每次插入注册一个新账户就必须为其分配一个单独的uid
	public static int createUid() {
		BasicDBObject oldObj = new BasicDBObject();
		oldObj.put(IDCounter.KEY, IDCounter.UID);
		BasicDBObject newObj = new BasicDBObject();
		newObj.put("$inc", new BasicDBObject().append(IDCounter.VALUE, 1));
		if (!DBController.update(IDCounter.COLLNAME, oldObj, newObj, true, false))
			return -1;
		DBCursor cursor = DBController.query(IDCounter.COLLNAME, oldObj);
		if (!cursor.hasNext())
			return -1;
		return (Integer) cursor.next().get(IDCounter.VALUE);
	}
	
	public static boolean updateInfo(int uid, Object ...args) {
		BasicDBObject oldObj = new BasicDBObject();
		oldObj.put(IDCounter.UID, uid);
		BasicDBObject newObj = new BasicDBObject();
		for (int i = 0; i < args.length; i+=2) {
			newObj.put(args[i].toString(), args[i+1]);
		}
		return DBController.update(UserConstant.COLLNAME, oldObj, newObj);
	}
	
	public static boolean downloadInfo(int uid, int seq) {
		BasicDBObject obj = new BasicDBObject();
		obj.put(IDCounter.UID, uid);
		DBCursor cursor = DBController.query(UserConstant.COLLNAME, obj);
		if (!cursor.hasNext()) {
			retString = "not found";
			return false;
		}
		DBObject retObj = cursor.next();
		if (Integer.parseInt(retObj.get(IDCounter.UID).toString()) == uid)
			retString = "Newest!";
		retString = retObj.toString();
		return true;
	}
	
	public static JSONObject retData = null;
	public static String retString = "";
}
