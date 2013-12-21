package cn.edu.hit.Dao;



import java.io.UnsupportedEncodingException;

import org.json.JSONException;
import org.json.JSONObject;

import com.mongodb.BasicDBObject;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.mongodb.util.JSON;


public class UserSimpleLogic {
	
	//��¼���ܵ�
	public static boolean login(String email, String password) throws JSONException {
		BasicDBObject obj = new BasicDBObject();
		retData = new JSONObject();
		obj.put(UserConstant.EMAIL, email);
		obj.put(UserConstant.PASSWORD, password);
		DBCursor cursor = DBController.query(UserConstant.COLLNAME, obj);
		if (!cursor.hasNext()) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		retData.put(HttpData.SUC, true);
		retData.put(UserConstant.UID, cursor.next().get(IDCounter.UID).toString());
		return true;
	}
	
	//ע�Ṧ��
	public static boolean register(String email, String password) throws JSONException, UnsupportedEncodingException {
		BasicDBObject obj = new BasicDBObject();
		retData = new JSONObject();
		obj.put(UserConstant.EMAIL, email);
		if (DBController.objExits(UserConstant.COLLNAME, obj)) {
			retData.put(HttpData.SUC, false);
			retData.put(HttpData.INFO, "������ʹ��");
			return false;
		}
		obj.put(UserConstant.PASSWORD, password);
		int uid = UserSimpleLogic.createUid();
		if (uid == -1) {
			retData.put(HttpData.SUC, false);
			retData.put(HttpData.INFO, "ע��ʧ��");
			return false;
		}
		obj.put(UserConstant.UID, uid);
		obj.put(UserConstant.SEQ, 1);
		retString = "" + uid;
		if (!DBController.addObj(UserConstant.COLLNAME, obj)) {
			retData.put(HttpData.SUC, false);
			retData.put(HttpData.INFO, "ע��ʧ��");
			return false;
		}
		if (!RelationshipLogic.createRelationship(uid)){
			DBController.removeObj(UserConstant.COLLNAME, obj);
			retData.put(HttpData.SUC, false);
			retData.put(HttpData.INFO, "ע��ʧ��");
			return false;
		}
		retData.put(HttpData.SUC, true);
		retData.put(UserConstant.UID, uid);
		retData.put(UserConstant.SEQ, 1);
		return true;
	}
	
	//ÿ�β���ע��һ�����˻��ͱ���Ϊ�����һ��������uid
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
	
	public static boolean updateInfo(int uid, String json) throws JSONException {
		BasicDBObject oldObj = new BasicDBObject();
		retData = new JSONObject();
		oldObj.put(IDCounter.UID, uid);
		BasicDBObject tmpObj = (BasicDBObject)JSON.parse(json);
		tmpObj.removeField(UserConstant.SEQ);
		BasicDBObject newObj = new BasicDBObject();
		newObj.put("$set", tmpObj);
		newObj.put("$inc", new BasicDBObject().append(UserConstant.SEQ, 1));
		boolean ret = DBController.update(UserConstant.COLLNAME, oldObj, newObj);
		if (!ret)
		{
			retData.put(HttpData.SUC, false);
			return false;
		}
		retData.put(HttpData.SUC, true);
		return true;
	}
	
	public static boolean downloadInfo(int uid, int seq) throws JSONException {
		BasicDBObject obj = new BasicDBObject();
		retData = new JSONObject();
		obj.put(IDCounter.UID, uid);
		DBCursor cursor = DBController.query(UserConstant.COLLNAME, obj);
		if (!cursor.hasNext()) {
			retData.put(HttpData.SUC, false);
			retData.put(HttpData.INFO, "not found");
			return false;
		}
		DBObject retObj = cursor.next();
		if (Integer.parseInt(retObj.get(UserConstant.SEQ).toString()) == seq) {
			retData.put(HttpData.SUC, false);
			retData.put(HttpData.INFO, "newest");
			return false;
		}
		retData.put(HttpData.SUC, true);
		retData.put(HttpData.DATA, retObj);
		return true;
	}
	
	public static JSONObject retData = null;
	public static String retString = "";
}
