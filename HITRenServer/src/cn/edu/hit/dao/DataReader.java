package cn.edu.hit.dao;

import org.json.JSONException;
import org.json.JSONObject;

import cn.edu.hit.constant.UserConstant;
import cn.edu.hit.model.Message;
import cn.edu.hit.model.User;

import com.mongodb.BasicDBObject;
import com.mongodb.DBObject;

public class DataReader {
	
	/**
	 * 获取最基础的用户信息
	 * @param uid
	 * @return
	 * @throws JSONException
	 */
	public static User getLeastUserInfo(int uid) throws JSONException {
		String name = "";
		String data = MemWorker.getUserInfo(uid);
		if (data != null) {
			JSONObject json = new JSONObject(data);
			name = json.getString(UserConstant.NAME);
		}
		else {
			BasicDBObject obj = new BasicDBObject(UserConstant.UID, uid);
			DBObject retObj = DBController.queryOne(UserConstant.COLLNAME, obj);
			if (retObj == null)
				return null;
			name = retObj.get(UserConstant.NAME).toString();
			MemWorker.setUserInfo(uid, retObj.toString());
		}
		User user = new User();
		user.setUid(uid);
		user.setName(name);
		
		return user;
	}
	
	/**
	 * 获取状态信息
	 * @param mid
	 * @return
	 * @throws JSONException
	 */
	public static Message getMessageInfo(int mid) throws JSONException {
		String data = MemWorker.getMessageInfo(mid);
		Message ret = new Message();
		
		if (data != null) {
			JSONObject json = new JSONObject(data);
			ret.setMid(json.getInt(cn.edu.hit.constant.Message.MID));
			ret.setUid(json.getInt(cn.edu.hit.constant.Message.UID));
			ret.setContent(json.getString(cn.edu.hit.constant.Message.CONTENT));
			ret.setType(json.getInt(cn.edu.hit.constant.Message.TYPE));
			ret.setTime(json.getString(cn.edu.hit.constant.Message.TIME));
			ret.setSeq(json.getInt(cn.edu.hit.constant.Message.SEQ));
		}
		else {
			return null;
//			BasicDBObject obj = new BasicDBObject(cn.edu.hit.constant.Message.MID, mid);
//			DBObject retObj = DBController.queryOne(cn.edu.hit.constant.Message.COLLNAME, obj);
//			if (retObj == null)
//				return null;
//			JSONObject json = new JSONObject(retObj.toString());
//			ret.setMid(json.getInt(cn.edu.hit.constant.Message.MID));
//			ret.setUid(json.getInt(cn.edu.hit.constant.Message.UID));
//			ret.setContent(json.getString(cn.edu.hit.constant.Message.CONTENT));
//			ret.setType(json.getInt(cn.edu.hit.constant.Message.TYPE));
//			ret.setTime(json.getString(cn.edu.hit.constant.Message.TIME));
//			ret.setSeq(json.getInt(cn.edu.hit.constant.Message.SEQ));
//			MemWorker.setMessageInfo(mid, retObj.toString());
		}
		return ret;
	}
	
	
	/**
	 * 从缓存获取状态
	 * @param mid
	 * @return
	 */
	public static String getMessage(int mid) {
		return MemWorker.getMessageInfo(mid);
	}
	
}
