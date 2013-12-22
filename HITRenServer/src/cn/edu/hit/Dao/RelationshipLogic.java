package cn.edu.hit.Dao;

import java.util.ArrayList;

import org.json.JSONException;
import org.json.JSONObject;

import com.mongodb.BasicDBObject;

public class RelationshipLogic {
	public static JSONObject retData;
	
	public static boolean createRelationship(int uid) throws JSONException {
		retData = new JSONObject();
		BasicDBObject obj = new BasicDBObject();
		obj.put(UserConstant.UID, uid);
		ArrayList<BasicDBObject> list = new ArrayList<BasicDBObject>();
		BasicDBObject defalut = new BasicDBObject();
		defalut.put(Relationship.GNAME, "default");
		list.add(defalut);
		obj.put(Relationship.CONCERNLIST, list);
		boolean ret = DBController.addObj(Relationship.COLLNAME, obj);
		if (!ret) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		retData.put(HttpData.SUC, true);
		return true;
	}
	
	public static boolean addGroup(int uid, String gname) throws JSONException {
		retData = new JSONObject();
		BasicDBObject oldObj = new BasicDBObject();
		oldObj.put(UserConstant.UID, uid);
		BasicDBObject newObj = new BasicDBObject();
		newObj.put("$addToSet", new BasicDBObject().append(Relationship.CONCERNLIST, 
				new BasicDBObject().append(Relationship.GNAME, gname)));
		boolean ret = DBController.update(Relationship.COLLNAME, oldObj, newObj);
		if (!ret) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		retData.put(HttpData.SUC, true);
		return true;
	}
	
	public static boolean deleteGroup(int uid, String gname) throws JSONException {
		retData = new JSONObject();
		BasicDBObject oldObj = new BasicDBObject();
		oldObj.put(UserConstant.UID, uid);
		BasicDBObject newObj = new BasicDBObject();
		newObj.put("$pull", new BasicDBObject().append(Relationship.CONCERNLIST, new BasicDBObject().append(Relationship.GNAME, gname)));
		boolean ret = DBController.update(Relationship.COLLNAME, oldObj, newObj);
		if (!ret) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		retData.put(HttpData.SUC, true);
		return true;
	}
	
	public static boolean renameGroup(int uid, String gname1, String gname2) throws JSONException {
		retData = new JSONObject();
		BasicDBObject oldObj = new BasicDBObject();
		oldObj.put(UserConstant.UID, uid);
		oldObj.put("concernlist.gname", gname1);
		BasicDBObject newObj = new BasicDBObject();
		newObj.put("$set", new BasicDBObject().append("concernlist.$.gname", gname2));
		boolean ret = DBController.update(Relationship.COLLNAME, oldObj, newObj);
		if (!ret) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		retData.put(HttpData.SUC, true);
		return true;
	}
	
	public static boolean copyUsersToGroup(int uid, ArrayList<Integer> users, String gname) throws JSONException {
		retData = new JSONObject();
		BasicDBObject oldObj = new BasicDBObject();
		oldObj.put(UserConstant.UID, uid);
		oldObj.put("concernlist.gname", gname);
		BasicDBObject newObj = new BasicDBObject();
		newObj.put("$addToSet", new BasicDBObject().append("concernlist.$.userlist", new BasicDBObject().append("$each", users)));
		boolean ret = DBController.update(Relationship.COLLNAME, oldObj, newObj);
		if (!ret) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		retData.put(HttpData.SUC, true);
		return true;
	}
	
	public static boolean deleteUserFromGroup(int uid, ArrayList<Integer> users, String gname) throws JSONException {
		retData = new JSONObject();
		BasicDBObject oldObj = new BasicDBObject();
		oldObj.put(UserConstant.UID, uid);
		oldObj.put("concernlist.gname", gname);
		BasicDBObject newObj = new BasicDBObject();
		newObj.put("$pullAll", new BasicDBObject().append("concernlist.$.userlist", users));
		boolean ret = DBController.update(Relationship.COLLNAME, oldObj, newObj);
		if (!ret) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		retData.put(HttpData.SUC, true);
		return true;
	}
	
	public static boolean moveUsersFromGroupToGroup(int uid, ArrayList<Integer>users, String gname1, String gname2) throws JSONException {
		boolean ret = RelationshipLogic.copyUsersToGroup(uid, users, gname2);
		if (!ret)
			return false;
		ret = RelationshipLogic.deleteUserFromGroup(uid, users, gname1);
		return ret;
	}
	
	public static boolean concernUserInGroup(int uid, String group, int uid1) throws JSONException {
		retData = new JSONObject();
		BasicDBObject oldObj = new BasicDBObject(UserConstant.UID, uid);
		oldObj.put(UserConstant.UID, uid);
		oldObj.put("concernlist.gname", group);
		BasicDBObject newObj = new BasicDBObject();
		newObj.append("$addToSet", new BasicDBObject().append("concernlist.$.userlist", uid1));
		boolean ret = DBController.update(Relationship.COLLNAME, oldObj, newObj);
		if (!ret) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		retData.put(HttpData.SUC, true);
		return true;
	}
}
