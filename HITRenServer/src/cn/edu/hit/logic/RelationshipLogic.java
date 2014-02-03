package cn.edu.hit.logic;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import cn.edu.hit.constant.HttpData;
import cn.edu.hit.constant.Relationship;
import cn.edu.hit.constant.UserConstant;
import cn.edu.hit.dao.DBController;
import cn.edu.hit.kit.LogKit;

import com.mongodb.BasicDBObject;
import com.mongodb.DBObject;

public class RelationshipLogic {
	public static JSONObject retData;
		
	public static boolean addGroup(int uid, String gname) throws JSONException {
		retData = new JSONObject();
		BasicDBObject oldObj = new BasicDBObject();
		oldObj.put(UserConstant.UID, uid);
		BasicDBObject newObj = new BasicDBObject();
		newObj.put("$addToSet", new BasicDBObject().append(Relationship.CONCERNLIST, 
				new BasicDBObject().append(Relationship.GNAME, gname).append(Relationship.USERLIST, new ArrayList<String>())));
		newObj.put("$inc", new BasicDBObject().append(Relationship.SEQ, 1));
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
		if (gname.equals(Relationship.DEFAULT) || gname.equals(Relationship.ALL)) {
			retData.put(HttpData.SUC, false);
			retData.put(HttpData.INFO, "无法删除这个分组");
			return false;
		}
		BasicDBObject obj1 = new BasicDBObject();
		obj1.put("uid", uid);
		obj1.put("concernlist.gname", gname);
		BasicDBObject obj2 = new BasicDBObject();
		obj2.put("concernlist.$.userlist", 1);
		DBObject retObj = DBController.queryOne(Relationship.COLLNAME, obj1, obj2);
		if (retObj == null) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		JSONObject json = new JSONObject(retObj.toString());
		json = new JSONObject(json.getJSONArray(Relationship.CONCERNLIST).get(0).toString());
		
		BasicDBObject oldObj = new BasicDBObject();
		oldObj.put(UserConstant.UID, uid);
		BasicDBObject newObj = new BasicDBObject();
		oldObj.put("concernlist.gname", "default");
		newObj = new BasicDBObject();
		JSONArray arr = json.getJSONArray("userlist");
		ArrayList<Integer> users = new ArrayList<Integer>();
		for (int i = 0; i < arr.length(); i++)
			users.add(arr.getInt(i));
		newObj.put("$addToSet", new BasicDBObject().append("concernlist.$.userlist",new BasicDBObject().append("$each", users)));
		boolean ret = DBController.update(Relationship.COLLNAME, oldObj, newObj);
		if (!ret) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		
		oldObj = new BasicDBObject();
		oldObj.put(UserConstant.UID, uid);
		newObj = new BasicDBObject();
		newObj.put("$pull", new BasicDBObject().append(Relationship.CONCERNLIST, new BasicDBObject().append(Relationship.GNAME, gname)));
		newObj.put("$inc", new BasicDBObject().append(Relationship.SEQ, 1));
		ret = DBController.update(Relationship.COLLNAME, oldObj, newObj);
		if (!ret) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		
		retData.put(HttpData.SUC, true);
		return true;
	}
	
	public static boolean renameGroup(int uid, String gname1, String gname2) throws JSONException {
		retData = new JSONObject();
		if (gname1.equals(Relationship.DEFAULT) || gname1.equals(Relationship.ALL)) {
			retData.put(HttpData.SUC, false);
			retData.put(HttpData.INFO, "无法重命名这个分组");
			return false;
		}
		BasicDBObject oldObj = new BasicDBObject();
		oldObj.put(UserConstant.UID, uid);
		oldObj.put("concernlist.gname", gname1);
		BasicDBObject newObj = new BasicDBObject();
		newObj.put("$set", new BasicDBObject().append("concernlist.$.gname", gname2));
		newObj.put("$inc", new BasicDBObject().append(Relationship.SEQ, 1));
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
		if (gname.equals(Relationship.ALL)) {
			retData.put(HttpData.SUC, false);
			retData.put(HttpData.INFO, "无法复制用户到这个分组");
			return false;
		}
		BasicDBObject oldObj = new BasicDBObject();
		oldObj.put(UserConstant.UID, uid);
		oldObj.put("concernlist.gname", gname);
		BasicDBObject newObj = new BasicDBObject();
		newObj.put("$addToSet", new BasicDBObject().append("concernlist.$.userlist", new BasicDBObject().append("$each", users)));
		newObj.put("$inc", new BasicDBObject().append(Relationship.SEQ, 1));
		boolean ret = DBController.update(Relationship.COLLNAME, oldObj, newObj);
		if (!ret) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		retData.put(HttpData.SUC, true);
		return true;
	}
	
	public static boolean deleteUsersFromGroup(int uid, ArrayList<Integer> users, String gname) throws JSONException {
		if (gname.equals(Relationship.ALL)) {
			retData = new JSONObject();
			retData.put(HttpData.SUC, false);
			retData.put(HttpData.INFO, "无法从这个分组删除好友");
			return false;
		}
		return RelationshipLogic.realDeleteUsersFromGroup(uid, users, gname);
	}
	
	private static boolean realDeleteUsersFromGroup(int uid, ArrayList<Integer> users, String gname) throws JSONException {
		retData = new JSONObject();
		BasicDBObject oldObj = new BasicDBObject();
		oldObj.put(UserConstant.UID, uid);
		oldObj.put("concernlist.gname", gname);
		BasicDBObject newObj = new BasicDBObject();
		newObj.put("$pullAll", new BasicDBObject().append("concernlist.$.userlist", users));
		newObj.put("$inc", new BasicDBObject().append(Relationship.SEQ, 1));
		boolean ret = DBController.update(Relationship.COLLNAME, oldObj, newObj);
		if (!ret) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		retData.put(HttpData.SUC, true);
		return true;
		
	}
	
	private static boolean deleteConcernedUserFromGroups(int uid, int uid1, ArrayList<String> gnames) throws JSONException {
		if (!gnames.contains(Relationship.ALL))
			gnames.add(Relationship.ALL);
		ArrayList<Integer> users = new ArrayList<Integer>();
		users.add(uid1);
		for (String gname:gnames)
			if (!RelationshipLogic.realDeleteUsersFromGroup(uid, users, gname)) {
				LogKit.err("deleteUsersFromGroup gname: %s", gname.toString());
				return false;
			}
		if (RelationshipLogic.removeAfollowerFromUid(uid, uid1))
		return true;
		return false;
	}
	
	public static boolean deleteConcernedUser(int uid, int uid1) throws JSONException {
		Map<String, ArrayList<Integer>> relationShip = RelationshipLogic.getRelationshipOfUser(uid);
		retData = new JSONObject();
		if (relationShip == null) {
			retData.put(HttpData.SUC, false);
			LogKit.err("relationship is null");
			return false;
		}
		ArrayList<String> gnames = new ArrayList<String>();
		for (String gname:relationShip.keySet())
			if (relationShip.get(gname).contains(uid1))
				gnames.add(gname);
		
		return RelationshipLogic.deleteConcernedUserFromGroups(uid, uid1, gnames);		
	}
	
	public static boolean moveUsersFromGroupToGroup(int uid, ArrayList<Integer>users, String gname1, String gname2) throws JSONException {
		retData = new JSONObject();
		if (gname2.equals(Relationship.DEFAULT) || gname1.equals(Relationship.ALL)) {
			retData.put(HttpData.SUC, false);
			retData.put(HttpData.INFO, "非法操作");
			return false;
		}
		boolean ret = RelationshipLogic.copyUsersToGroup(uid, users, gname2);
		if (!ret)
			return false;
		ret = RelationshipLogic.deleteUsersFromGroup(uid, users, gname1);
		return ret;
	}
	
	// 之后可以把addtoset改成push
	public static boolean concernUserInGroup(int uid, String group, int uid1) throws JSONException {
		retData = new JSONObject();
		BasicDBObject oldObj = new BasicDBObject();
		oldObj.put(Relationship.UID, uid);
		oldObj.put("concernlist.gname", group);
		BasicDBObject newObj = new BasicDBObject();
		newObj.append("$addToSet", new BasicDBObject().append("concernlist.$.userlist", uid1));
		newObj.put("$inc", new BasicDBObject().append(Relationship.SEQ, 1));
		boolean ret = DBController.update(Relationship.COLLNAME, oldObj, newObj);
		if (!ret) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		
		//被关注者的followlist里要加入关注他的人
		ret = RelationshipLogic.addAfollowerToUid(uid, uid1);
		if (!ret) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		retData.put(HttpData.SUC, true);
		return true;
	}
	
	public static boolean concernUserInGroups(int uid, ArrayList<String> gnames, int uid1) throws JSONException {
		if (!gnames.contains(Relationship.ALL))
			gnames.add(Relationship.ALL);
		if (gnames.size() == 1)
			gnames.add(Relationship.DEFAULT);
		for (String gname : gnames)
			if (!RelationshipLogic.concernUserInGroup(uid, gname, uid1))
				return false;
		return true;
	}
	
	// 之后可以把addtoset改成push
	public static boolean addAfollowerToUid(int followerid, int uid) throws JSONException {
		retData = new JSONObject();
		BasicDBObject oldObj = new BasicDBObject();
		oldObj.put(Relationship.UID, uid);
		BasicDBObject newObj = new BasicDBObject();
		newObj.put("$addToSet", new BasicDBObject().append(Relationship.FOLLOWLIST, followerid));
		newObj.put("$inc", new BasicDBObject().append(Relationship.SEQ, 1));
		boolean ret = DBController.update(Relationship.COLLNAME, oldObj, newObj);
		if (!ret) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		retData.put(HttpData.SUC, true);
		return true;
	}
	
	public static boolean removeAfollowerFromUid(int followid, int uid) throws JSONException {
		retData = new JSONObject();
		BasicDBObject oldObj = new BasicDBObject();
		oldObj.put(Relationship.UID, uid);
		BasicDBObject newObj = new BasicDBObject();
		newObj.put("$pull", new BasicDBObject().append(Relationship.FOLLOWLIST, followid));
		newObj.put("$inc", new BasicDBObject().append(Relationship.SEQ, 1));
		boolean ret = DBController.update(Relationship.COLLNAME, oldObj, newObj);
		if (!ret) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		retData.put(HttpData.SUC, true);
		return true;
	}
	
	public static boolean moveUsersToBlacklist(int uid, ArrayList<Integer> users) throws JSONException {
		retData = new JSONObject();
		BasicDBObject oldObj = new BasicDBObject();
		oldObj.put(Relationship.UID, uid);
		BasicDBObject newObj = new BasicDBObject();
		newObj.put("$addToSet", new BasicDBObject().append(Relationship.BLACKLIST, new BasicDBObject().append("$each", users)));
		newObj.put("$inc", new BasicDBObject().append(Relationship.SEQ, 1));
		boolean ret = DBController.update(Relationship.COLLNAME, oldObj, newObj);
		if (!ret) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		retData.put(HttpData.SUC, true);
		return true;
	}
	
	public static boolean recoverUsersToBlacklist(int uid, ArrayList<Integer> users) throws JSONException {
		retData = new JSONObject();
		BasicDBObject oldObj = new BasicDBObject();
		oldObj.put(Relationship.UID, uid);
		BasicDBObject newObj = new BasicDBObject();
		newObj.put("$pullAll", new BasicDBObject().append(Relationship.BLACKLIST, users));
		newObj.put("$inc", new BasicDBObject().append(Relationship.SEQ, 1));
		boolean ret = DBController.update(Relationship.COLLNAME, oldObj, newObj);
		if (!ret) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		retData.put(HttpData.SUC, true);
		return true;
	}
	
	public static boolean downloadRelationshipInfo(int uid,int seq) throws JSONException {
		retData = new JSONObject();
		BasicDBObject obj = new BasicDBObject();
		obj.put(Relationship.UID, uid);
		obj.put(Relationship.SEQ, new BasicDBObject().append("$gt", seq));
		DBObject retObj = DBController.queryOne(Relationship.COLLNAME, obj);
		if (retObj == null) {
			retData.put(HttpData.SUC, false);
			retData.put(HttpData.INFO, "newest");
			return false;
		}
		retData.put(HttpData.SUC, true);
		retData.put(HttpData.DATA, retObj);
		return true;
	}
	
	public static Map<String, ArrayList<Integer>> getRelationshipOfUser(int uid) throws JSONException {
		BasicDBObject obj1 = new BasicDBObject();
		obj1.put(Relationship.UID, uid);
		BasicDBObject obj2 = new BasicDBObject();
		obj2.put(Relationship.CONCERNLIST, 1);
		DBObject retObj = DBController.queryOne(Relationship.COLLNAME, obj1, obj2);
		if (retObj == null)
			return null;
		LogKit.debug("get relationship from database: %s", retObj.toString());
		Map<String, ArrayList<Integer>> retMap = new HashMap<String, ArrayList<Integer>>();
		JSONArray jsonArray = new JSONObject(retObj.toString()).getJSONArray(Relationship.CONCERNLIST);
		for (int i = 0; i < jsonArray.length(); i++) {
			JSONObject json = new JSONObject(jsonArray.get(i).toString());
			String gname = json.getString(Relationship.GNAME);
			JSONArray users0 = json.getJSONArray(Relationship.USERLIST);
			ArrayList<Integer> users = new ArrayList<Integer>();
			for (int j = 0; j < users0.length(); j++)
				users.add(users0.getInt(j));
			retMap.put(gname, users);
		}
		return retMap;
//		return retObj;
	}
}
