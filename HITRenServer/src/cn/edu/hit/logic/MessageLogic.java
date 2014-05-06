package cn.edu.hit.logic;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import cn.edu.hit.constant.Comment;
import cn.edu.hit.constant.HttpData;
import cn.edu.hit.constant.IDCounter;
import cn.edu.hit.constant.LikedList;
import cn.edu.hit.constant.Message;
import cn.edu.hit.constant.TimeLine;
import cn.edu.hit.dao.DBController;
import cn.edu.hit.dao.DataReader;
import cn.edu.hit.dao.MemWorker;
import cn.edu.hit.kit.LogKit;
import cn.edu.hit.kit.TimeKit;
import cn.edu.hit.model.User;
import cn.edu.hit.openfire.TipsPusher;

import com.mongodb.BasicDBList;
import com.mongodb.BasicDBObject;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.mongodb.util.JSON;

public class MessageLogic {
	public static JSONObject retData;
	public static Logger logger = Logger.getRootLogger();
	
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
			logger.error("createMid failed");
			retData.put(HttpData.SUC, false);
			return false;
		}
		logger.info("createMid succ");
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
		MemWorker.setMessageInfo(mid, obj.toString());
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
	 * 下载timeline中的mid列表，可能和客户端中已经存在的有重复
	 * @param seq
	 * @return
	 * @throws JSONException
	 */
	public static boolean downloadTimeline(int seq) throws JSONException {
		retData = new JSONObject();
		BasicDBObject obj1 = new BasicDBObject(TimeLine.UID, 0);
		int[] range = {0, 10000};
		BasicDBObject obj2 = new BasicDBObject(TimeLine.LIST, new BasicDBObject("$slice", range));
		DBObject retObj = DBController.queryOne(TimeLine.GLOBAL, obj1, obj2);
		if (retObj == null) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		retData.put(HttpData.SUC, true);
		int seq0 = Integer.parseInt(retObj.get(TimeLine.SEQ).toString());
		if (seq == seq0) {
			retData.put(HttpData.INFO, "newest");
			return true;
		}
		JSONObject data = new JSONObject();
		data.put("seq", seq0);
		BasicDBList retList = (BasicDBList) retObj.get(TimeLine.LIST);
		int len = retList.size();
		if (len > seq0 - seq + 100)
			data.put("mids", retList.subList(0, seq0 - seq + 100));
		else
			data.put("mids", retList);
			retData.put(HttpData.DATA, data);	
		return true;
	}
	
	/**
	 * 下载mids中的所有状态数据
	 * @param mids
	 * @return
	 * @throws JSONException
	 */
	public static boolean downloadMessages(ArrayList<Integer>mids) throws JSONException {
		retData = new JSONObject();
		JSONObject json = new JSONObject();
		Map<Integer, String> data = new HashMap<Integer, String>();
		for (int i = mids.size()-1; i >= 0; i--) {
			int mid = mids.get(i);
			String info = DataReader.getMessage(mid);
			if (info != null) {
//				data.put(mid, info);
				json.put(mid+"", new JSONObject(info));
				mids.remove(i);
			}
		}
		BasicDBObject obj = new BasicDBObject();
		obj.put(Message.MID, new BasicDBObject("$in", mids));
		DBCursor cursor = DBController.query(Message.COLLNAME, obj);
		while (cursor.hasNext()) {
			DBObject retObj = cursor.next();
			logger.info(retObj);
			json.put(retObj.get(Message.MID).toString(), retObj);
		}
		retData.put(HttpData.SUC, true);
		retData.put(HttpData.DATA, json);
		return true;
	}
	
	/**
	 * 下载状态数据
	 * @param uid
	 * @param gseq
	 * @param useq
	 * @param index 开始找的状态下标
	 * @return
	 */
	public static boolean downloadMessages(int uid, int gseq, int index) {
		retData = new JSONObject();
		
		
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
//		BasicDBObject oldObj = new BasicDBObject(Message.MID, mid);
//		BasicDBObject newObj = new BasicDBObject();
//		BasicDBObject userInfo = new BasicDBObject();
//		userInfo.put(Message.LIKEDINFO.UID, uid);
//		User user = DataReader.getLeastUserInfo(uid);
////		userInfo.put(Message.LIKEDINFO.UNAME, user.getName());
//		newObj.put("$push", new BasicDBObject().append(Message.LIKEDLIST, userInfo));
//		newObj.put("$inc", new BasicDBObject(Message.SEQ, 1));
//		boolean ret = DBController.update(Message.COLLNAME, oldObj, newObj, false, false);
//		if (!ret) {
//			retData.put(HttpData.SUC, false);
//			return false;
//		}
//		DBObject retObj = DBController.queryOne(Message.COLLNAME, oldObj);
//		ret = MemWorker.setMessageInfo(mid, retObj.toString());
//		if (!ret) {
//			retData.put(HttpData.SUC, false);
//			return false;
//		}
		BasicDBObject oldObj = new BasicDBObject(LikedList.MID, mid);
		BasicDBObject newObj = new BasicDBObject("$addToSet", new BasicDBObject(LikedList.LIST, uid));
		newObj.put("$inc", new BasicDBObject(LikedList.SEQ, 1));
		boolean ret = DBController.update(LikedList.COLLNAME, oldObj, newObj, true, false);
		if (!ret) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		int uid0 = 0;
		String messageInfo = DataReader.getMessage(mid);
		if (messageInfo != null) {
			JSONObject json = new JSONObject(messageInfo);
			uid0 = json.getInt("uid");
		}
		else {
			DBObject retObj = DBController.queryOne(Message.COLLNAME, oldObj);
			uid0 = Integer.parseInt(retObj.get(Message.UID).toString());
		}
		User user = DataReader.getLeastUserInfo(uid);
//		int uid0 = Integer.parseInt(retObj.get(Message.UID).toString());
		TipsPusher.messageIsLikedByUser(uid0, uid, user.getName(), "", mid);
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
//		BasicDBObject oldObj = new BasicDBObject(Message.MID, mid);
//		BasicDBObject newObj = new BasicDBObject();
//		newObj = newObj.append("$pull", new BasicDBObject(Message.LIKEDLIST, new BasicDBObject(Message.UID, uid)));
//		newObj = newObj.append("$inc", new BasicDBObject(Message.SEQ, 1));
//		boolean ret = DBController.update(Message.COLLNAME, oldObj, newObj, false, false);
//		if (!ret) {
//			retData.put(HttpData.SUC, false);
//			return false;
//		}
//		DBObject retObj = DBController.queryOne(Message.COLLNAME, oldObj);
//		ret = MemWorker.setMessageInfo(mid, retObj.toString());
//		if (!ret) {
//			retData.put(HttpData.SUC, false);
//			return false;
//		}
		BasicDBObject oldObj = new BasicDBObject(LikedList.MID, mid);
		BasicDBObject newObj = new BasicDBObject("$pull", new BasicDBObject(LikedList.LIST, uid));
		newObj.put("$inc", new BasicDBObject(LikedList.SEQ, 1));
		boolean ret = DBController.update(LikedList.COLLNAME, oldObj, newObj, false, false);
		if (!ret) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		retData.put(HttpData.SUC, true);
		return true;
	}
	
	/**
	 * 评论状态
	 * @param uid 评论者
	 * @param mid 相关状态
	 * @param reuid 被评论的uid，如果是状态本人，则可传-1
	 * @param content 评论的内容
	 * @return
	 * @throws Exception
	 */
	public static boolean commentMessage(int uid, int mid, int reuid, String content) throws Exception {
		retData = new JSONObject();
		BasicDBObject oldObj = new BasicDBObject(Comment.CID, mid);
		BasicDBObject newObj = new BasicDBObject();
		BasicDBObject dataObj = new BasicDBObject();
		dataObj.put(Comment.UID, uid);
		dataObj.put(Comment.REUID, reuid);
		dataObj.put(Comment.CONTENT, content);
		dataObj.put(Comment.TIME, TimeKit.now());
		newObj.put("$push", new BasicDBObject(Comment.LIST, dataObj));
		newObj.put("$inc", new BasicDBObject(Comment.SEQ, 1));
		if (!DBController.update(Comment.COLLNAME, oldObj, newObj, true, false)) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		int uid1 = reuid;
		if (uid1 == -1) {
			cn.edu.hit.model.Message message = DataReader.getMessageInfo(mid);
			uid1 = message.getUid();
		}
		User user = DataReader.getLeastUserInfo(uid);
		TipsPusher.messageIsCommentedByUser(uid1, uid, user.getName(), user.getPic(), mid);
		return true;
	}
	
	/**
	 * 分享状态
	 * @param uid 分享者
	 * @param mid1 相关状态
	 * @param content 分享时的描述
	 * @return
	 * @throws Exception 
	 */
	public static boolean shareMessage(int uid, int mid1, String content, ArrayList<String> gnames) throws Exception {
		retData = new JSONObject();
		int mid = createMid();
		if (mid == -1) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		String now = TimeKit.now();
		int type = Message.Type.SHARED;
		BasicDBObject obj = new BasicDBObject();
		obj.put(Message.MID, mid);
		obj.put(Message.UID, uid);
		obj.put(Message.TIME, now);
		obj.put(Message.SEQ, 1);
		obj.put(Message.LIKEDLIST, new ArrayList<String>());
		obj.put(Message.SHATECOUNT, 0);
		obj.put(Message.TYPE, type);
		obj.put(Message.PRE, content);
		
		BasicDBObject contentObj = new BasicDBObject();
		cn.edu.hit.model.Message message = DataReader.getMessageInfo(mid1);
		contentObj.put(Message.UID, message.getUid());
		contentObj.put(Message.TYPE, message.getType());
		contentObj.put(Message.CONTENT, message.getContent());
		contentObj.put(Message.PRE, message.getPrefix());
		
		obj.put(Message.CONTENT, contentObj);
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
		
		BasicDBObject oldObj = new BasicDBObject();
		oldObj.put(Message.MID, mid1);
		BasicDBObject newObj = new BasicDBObject();
		newObj.put("$inc", new BasicDBObject(Message.SEQ, 1).append(Message.SHATECOUNT, 1));
		if (!DBController.update(Message.COLLNAME, oldObj, newObj)) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		
		User user = DataReader.getLeastUserInfo(uid);
		TipsPusher.messageIsSharedByUser(message.getUid(), uid, user.getName(), user.getPic(), mid1);
		MemWorker.deleteMessageInfo(mid1);
		retData.put(HttpData.SUC, true);
		return true;
	}
	
	/**
	 * 举报状态
	 * @param uid 举报者
	 * @param mid 被举报的状态
	 * @return
	 * @throws Exception 
	 */
	public static boolean reportMessage(int uid, int mid) throws Exception {
		retData = new JSONObject();
		BasicDBObject oldObj = new BasicDBObject(Message.MID, mid);
		BasicDBObject newObj = new BasicDBObject();
		newObj.put("$push", new BasicDBObject(Message.REPORTLIST, new BasicDBObject(Message.REPORTINFO.UID, uid)));
		newObj.put("$inc", new BasicDBObject(Message.REPORTCOUNT, 1));
		newObj.put("$inc", new BasicDBObject(Message.SEQ, 1));
		if (!DBController.update(Message.COLLNAME, oldObj, newObj)) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		cn.edu.hit.model.Message message = DataReader.getMessageInfo(mid);
		User user = DataReader.getLeastUserInfo(uid);
		TipsPusher.messageIsReportedByUser(message.getUid(), uid, user.getName(), user.getPic(), mid);
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
