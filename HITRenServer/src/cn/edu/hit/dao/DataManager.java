package cn.edu.hit.dao;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import cn.edu.hit.constant.Message;

import com.mongodb.BasicDBObject;
import com.mongodb.DBObject;

public class DataManager {
	/**
	 * 获取状态信息，不缓存
	 * @param mid
	 * @return
	 * @throws JSONException
	 */
	public static JSONObject getMessage(int mid) throws JSONException {
		return DataManager.getMessage(mid, false);
	}
	
	/**
	 * 获取状态信息
	 * @param mid
	 * @param cache 是否缓存
	 * @return
	 * @throws JSONException
	 */
	public static JSONObject getMessage(int mid, boolean cache) throws JSONException {
		String info = DataReader.getMessage(mid);
		if (info !=null && info != "") return new JSONObject(info);
		BasicDBObject obj = new BasicDBObject(Message.MID, mid);
		DBObject retObj = DBController.queryOne(Message.COLLNAME, obj);
		if (cache)
			MemWorker.setMessageInfo(mid, retObj.toString());
		return new JSONObject(retObj.toString());
	}
	
	private static Logger logger = Logger.getRootLogger();
}
