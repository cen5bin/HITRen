package cn.edu.hit.Dao;

import com.mongodb.BasicDBObject;
import com.mongodb.DBCursor;


public class UserSimpleLogic {
	
	public static boolean login(String email, String password) {
		BasicDBObject obj = new BasicDBObject();
		obj.put(UserConstant.EMAIL, email);
		obj.put(UserConstant.PASSWORD, password);
		return DBController.objExits(UserConstant.COLLNAME, obj);
	}
	
	public static boolean register(String email, String password) {
		BasicDBObject obj = new BasicDBObject();
		obj.put(UserConstant.EMAIL, email);
		if (DBController.objExits(UserConstant.COLLNAME, obj))
			return false; 
		obj.put(UserConstant.PASSWORD, password);
		int uid = UserSimpleLogic.createUid();
		System.out.println(uid);
		if (uid == -1)
			return false;
		obj.put(UserConstant.UID, uid);
		return DBController.addObj(UserConstant.COLLNAME, obj);
	}
	
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
	
	public static String errString = "";
}
