package cn.edu.hit.logic;



import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;
import org.jivesoftware.smack.XMPPException;
import org.json.JSONException;
import org.json.JSONObject;

import cn.edu.hit.constant.HttpData;
import cn.edu.hit.constant.IDCounter;
import cn.edu.hit.constant.Notice;
import cn.edu.hit.constant.Relationship;
import cn.edu.hit.constant.TimeLine;
import cn.edu.hit.constant.UserConstant;
import cn.edu.hit.dao.DBController;
import cn.edu.hit.dao.DataReader;
import cn.edu.hit.dao.MemWorker;
import cn.edu.hit.kit.LogKit;
import cn.edu.hit.openfire.AccountManager;

import com.mongodb.BasicDBObject;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.mongodb.util.JSON;


public class UserSimpleLogic {
	
	//登录功能的
	public static boolean login(String email, String password) throws JSONException {
		BasicDBObject obj = new BasicDBObject();
		retData = new JSONObject();
		obj.put(UserConstant.EMAIL, email);
		obj.put(UserConstant.PASSWORD, password);
		DBObject retObject = DBController.queryOne(UserConstant.COLLNAME, obj);
		if (retObject == null) {
			retData.put(HttpData.SUC, false);
			return false;
		}
//		DBCursor cursor = DBController.query(UserConstant.COLLNAME, obj);
//		if (!cursor.hasNext()) {
//			retData.put(HttpData.SUC, false);
//			return false;
//		}
		retData.put(HttpData.SUC, true);
		retData.put(UserConstant.UID, retObject.get(IDCounter.UID).toString());
		return true;
	}
	
	//注册功能
	public static boolean register(String email, String password) throws JSONException, XMPPException, IOException {
		BasicDBObject obj = new BasicDBObject();
		retData = new JSONObject();
		obj.put(UserConstant.EMAIL, email);
		if (DBController.objExits(UserConstant.COLLNAME, obj)) {
			retData.put(HttpData.SUC, false);
			retData.put(HttpData.INFO, "邮箱已使用");
			return false;
		}
		obj.put(UserConstant.PASSWORD, password);
		int uid = UserSimpleLogic.createUid();
		if (uid == -1) {
			retData.put(HttpData.SUC, false);
			retData.put(HttpData.INFO, "注册失败");
			return false;
		}
		obj.put(UserConstant.UID, uid);
		obj.put(UserConstant.SEQ, 1);
		obj.put(UserConstant.NAME, email);
		retString = "" + uid;
		if (!DBController.addObj(UserConstant.COLLNAME, obj)) {
			retData.put(HttpData.SUC, false);
			retData.put(HttpData.INFO, "注册失败");
			return false;
		}
		if (!UserSimpleLogic.createRelationship(uid)){
			DBController.removeObj(UserConstant.COLLNAME, obj);
			retData.put(HttpData.SUC, false);
			retData.put(HttpData.INFO, "relationship 建立失败");
			return false;
		}
		if (!UserSimpleLogic.createTimeline(uid)) {
			retData.put(HttpData.SUC, false);
			retData.put(HttpData.INFO, "timeline 建立失败");
			return false;
		}
		if (!UserSimpleLogic.createNotice(uid)) {
			retData.put(HttpData.SUC, false);
			retData.put(HttpData.INFO, "notice 建立失败");
			return false;
		}
		AccountManager.createAccount(uid, password);
		retData.put(HttpData.SUC, true);
		retData.put(UserConstant.UID, uid);
		retData.put(UserConstant.SEQ, 1);
		return true;
	}
	
	//为当前注册用户建好友关系表
	private static boolean createRelationship(int uid) throws JSONException {
		retData = new JSONObject();
		BasicDBObject obj = new BasicDBObject();
		obj.put(UserConstant.UID, uid);
		ArrayList<BasicDBObject> list = new ArrayList<BasicDBObject>();
		BasicDBObject defalut = new BasicDBObject();
		defalut.put(Relationship.GNAME, Relationship.DEFAULT);
		defalut.put(Relationship.USERLIST, new ArrayList<Integer>());
		list.add(defalut);
		BasicDBObject all = new BasicDBObject();
		all.put(Relationship.GNAME, Relationship.ALL);
		all.put(Relationship.USERLIST, new ArrayList<Integer>());
		list.add(all);
		obj.put(Relationship.CONCERNLIST, list);
		obj.put(Relationship.SEQ, 1);
		boolean ret = DBController.addObj(Relationship.COLLNAME, obj);
		if (!ret) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		retData.put(HttpData.SUC, true);
		return true;
	}
	
	public static boolean downloadUsersData(ArrayList<Integer> users) throws JSONException {
		retData = new JSONObject();
		JSONObject json = new JSONObject();
		for (int i = users.size() - 1; i >= 0; i--) {
			int uid = users.get(i);
			String userInfo = DataReader.getUser(uid);
			if (userInfo == null) continue;
			json.put(uid+"", new JSONObject(userInfo));
			users.remove(i);
		}
		logger.info(users);
		BasicDBObject obj = new BasicDBObject(UserConstant.UID, new BasicDBObject("$in", users));
		logger.info(obj);
		DBCursor cursor = DBController.query(UserConstant.COLLNAME, obj);
		while (cursor.hasNext()) {
			DBObject retObj = cursor.next();
			logger.info(retObj.toString());
			int uid = Integer.parseInt(retObj.get("uid").toString());
			json.put(uid+"", retObj);
			MemWorker.setUserInfo(uid, retObj.toString());
		}
		retData.put(HttpData.SUC, true);
		retData.put(HttpData.DATA, json);
		return true;
	}
	
	// 为当前注册用户建立timeline
	private static boolean createTimeline(int uid) {
		BasicDBObject obj = new BasicDBObject(TimeLine.UID, uid);
		obj.put(TimeLine.SEQ, 1);
		obj.put(TimeLine.LIST, new ArrayList<Integer>());
		boolean ret = DBController.addObj(TimeLine.COLLNAME, obj);
		if (!ret)
			LogKit.err("createTimeline failed");
		return ret;
	}
	
	/**
	 * 为用户建立notice记录
	 * @param uid
	 * @return
	 */
	private static boolean createNotice(int uid) {
		BasicDBObject obj = new BasicDBObject(Notice.UID, uid);
		obj.put(Notice.SEQ, 1);
		obj.put(Notice.LIST, new ArrayList<String>());
		boolean ret = DBController.addObj(Notice.COLLNAME, obj);
		if (!ret)
			LogKit.err("createNotice failed");
		return ret;
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
	
	public static boolean newDownloadUserInfo(ArrayList<JSONObject> datas) throws JSONException {
		retData = new JSONObject();
		ArrayList<Integer> uids = new ArrayList<Integer>();
		Map<Integer, Integer> map = new HashMap<Integer, Integer>();
		for (JSONObject json : datas) {
			int mid = json.getInt("uid");
			int seq = json.getInt("seq");
			map.put(mid, seq);
			uids.add(json.getInt("uid"));
		}
		BasicDBObject obj = new BasicDBObject(UserConstant.UID, new BasicDBObject("$in", uids));
		DBCursor cursor = DBController.query(UserConstant.COLLNAME, obj);
		JSONObject ret = new JSONObject();
		while (cursor.hasNext()) {
			DBObject retObj = cursor.next();
			int seq0 = map.get(retObj.get(UserConstant.UID));
			int seq1 = Integer.parseInt(retObj.get(UserConstant.SEQ).toString());
			if (seq0 >= seq1) continue;
			ret.put(retObj.get(UserConstant.UID).toString(), retObj);
			logger.info(retObj);
		}
		retData.put(HttpData.SUC, true);
		retData.put(HttpData.DATA, ret);

		return true;
	}
	
	public static JSONObject retData = null;
	public static Logger logger = Logger.getRootLogger();
	public static String retString = "";
}
