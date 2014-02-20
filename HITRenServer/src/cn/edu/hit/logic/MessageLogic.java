package cn.edu.hit.logic;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import org.json.JSONException;
import org.json.JSONObject;

import cn.edu.hit.constant.HttpData;
import cn.edu.hit.constant.IDCounter;
import cn.edu.hit.constant.Message;
import cn.edu.hit.constant.TimeLine;
import cn.edu.hit.dao.DBController;
import cn.edu.hit.dao.DataReader;
import cn.edu.hit.dao.MemWorker;
import cn.edu.hit.kit.LogKit;
import cn.edu.hit.kit.TimeKit;
import cn.edu.hit.model.User;
import cn.edu.hit.openfire.TipsPusher;

import com.mongodb.BasicDBObject;
import com.mongodb.DBObject;

public class MessageLogic {
	public static JSONObject retData;
	
	/**
	 * 发纯文字状态
	 * @param uid 作者
	 * @param message 状态内容
	 * @param gnames  能看到该状态的好友分组，如果传空数组表示所有人可见
	 * @return
	 * @throws JSONException
	 */
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
		obj.put(Message.SEQ, 1);
//		sobj.put(Message.COMMENTLIST, new ArrayList<String>());
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
	
	/**
	 * 用户uid为状态mid点赞
	 * @param uid 点赞者
	 * @param mid 被点赞的状态
	 * @return
	 * @throws Exception 
	 */
	public static boolean likeTheMessage(int uid, int mid) throws Exception {
		retData = new JSONObject();
		BasicDBObject oldObj = new BasicDBObject(Message.MID, mid);
		BasicDBObject newObj = new BasicDBObject();
		BasicDBObject userInfo = new BasicDBObject();
		userInfo.put(Message.LIKEDINFO.UID, uid);
		User user = DataReader.getLeastUserInfo(uid);
//		userInfo.put(Message.LIKEDINFO.UNAME, user.getName());
		newObj.put("$push", new BasicDBObject().append(Message.LIKEDLIST, userInfo));
		newObj.put("$inc", new BasicDBObject(Message.SEQ, 1));
		boolean ret = DBController.update(Message.COLLNAME, oldObj, newObj, false, false);
		if (!ret) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		DBObject retObj = DBController.queryOne(Message.COLLNAME, oldObj);
		ret = MemWorker.setMessageInfo(mid, retObj.toString());
		if (!ret) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		
		int uid0 = Integer.parseInt(retObj.get(Message.UID).toString());
		TipsPusher.messageIsLikedByUser(uid0, uid, user.getName());
		retData.put(HttpData.SUC, true);
		return true;
	}
	
	/**
	 * 取消点赞
	 * @param uid 取消点赞者
	 * @param mid 被取消的状态
	 * @return
	 * @throws JSONException
	 */
	public static boolean cancelLikeTheMessage(int uid, int mid) throws JSONException {
		retData = new JSONObject();
		BasicDBObject oldObj = new BasicDBObject(Message.MID, mid);
		BasicDBObject newObj = new BasicDBObject();
		newObj = newObj.append("$pull", new BasicDBObject(Message.LIKEDLIST, new BasicDBObject(Message.UID, uid)));
		newObj = newObj.append("$inc", new BasicDBObject(Message.SEQ, 1));
		boolean ret = DBController.update(Message.COLLNAME, oldObj, newObj, false, false);
		if (!ret) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		DBObject retObj = DBController.queryOne(Message.COLLNAME, oldObj);
		ret = MemWorker.setMessageInfo(mid, retObj.toString());
		if (!ret) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		retData.put(HttpData.SUC, true);
		return true;
	}
	
	/**
	 * 为每一条状态生成一个mid
	 * @return
	 */
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
	
	/**
	 * 将状态插入到全局timeline
	 * @param mid
	 * @return
	 */
	private static boolean addMessageToGlobalTimeline(int mid) {
		BasicDBObject oldObj = new BasicDBObject(TimeLine.UID, 0);
		BasicDBObject newObj = new BasicDBObject("$push", new BasicDBObject(TimeLine.LIST, mid));
		newObj.put("$inc", new BasicDBObject(TimeLine.SEQ, 1));
		return DBController.update(TimeLine.GLOBAL, oldObj, newObj, true, false);
	}
	
	/**
	 * 将状态插入到gnames中所有分组的所有人的timeline中
	 * @param uid
	 * @param mid
	 * @param gnames
	 * @return
	 * @throws JSONException
	 */
	private static boolean addMessageToGroups(int uid, int mid, ArrayList<String> gnames) throws JSONException {
		Map<String, ArrayList<Integer>> relationShip = RelationshipLogic.getRelationshipOfUser(uid);
		Set<Integer> users = new HashSet<Integer>();
		for (String gname : gnames) {
			users.addAll(relationShip.get(gname));
		}
		return MessageLogic.addMessageToUsers(mid, users);
	}
	
	/**
	 * 将状态插入到users中每个人的timeline中
	 * @param mid
	 * @param users
	 * @return
	 */
	private static boolean addMessageToUsers(int mid, Collection<Integer> users) {
		BasicDBObject oldObj = new BasicDBObject(TimeLine.UID, new BasicDBObject("$in", users));
		BasicDBObject newObj = new BasicDBObject("$push", new BasicDBObject(TimeLine.LIST, mid));
		newObj.put("$inc", new BasicDBObject(TimeLine.SEQ, 1));
		boolean ret = DBController.update(TimeLine.COLLNAME, oldObj, newObj, false, true);
		if (!ret)
			LogKit.err("addMessageToUsers failed");
		return ret;
	}
	
	/**
	 * 将状态插入到自己的timeline中
	 * @param uid
	 * @param mid
	 * @return
	 */
	private static boolean addMessageToSelf(int uid, int mid) {
		ArrayList<Integer> users = new ArrayList<Integer>();
		users.add(uid);
		return MessageLogic.addMessageToUsers(mid, users);
	}
}
