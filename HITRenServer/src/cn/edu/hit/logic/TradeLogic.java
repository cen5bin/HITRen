package cn.edu.hit.logic;

import java.util.ArrayList;

import org.json.JSONException;
import org.json.JSONObject;

import cn.edu.hit.constant.Goods;
import cn.edu.hit.constant.GoodsLine;
import cn.edu.hit.constant.HttpData;
import cn.edu.hit.constant.IDCounter;
import cn.edu.hit.dao.DBController;
import cn.edu.hit.kit.TimeKit;

import com.mongodb.BasicDBList;
import com.mongodb.BasicDBObject;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

public class TradeLogic extends BaseLogic {
	/**
	 * 上传商品信息
	 * @param name
	 * @param price
	 * @param pics
	 * @param desc
	 * @return
	 * @throws JSONException 
	 */
	public static boolean uploadGoodsInfo(int uid, String name, String price, ArrayList<String> pics, String desc) throws JSONException {
		retData = new JSONObject();
		BasicDBObject obj = new BasicDBObject();
		int gid = createGid();
		obj.put(Goods.GID, gid);
		obj.put(Goods.NAME, name);
		obj.put(Goods.PRICE, price);
		obj.put(Goods.PICS, pics);
		obj.put(Goods.DESCRIPTION, desc);
		obj.put(Goods.UID, uid);
		obj.put(Goods.TIME, TimeKit.now());
		if (!DBController.addObj(Goods.COLLNAME, obj)) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		addToGoodsLine(gid);
		retData.put(HttpData.SUC, true);
		return true;
	}
	
	/**
	 * 下载商品信息
	 * @param gids
	 * @return
	 * @throws JSONException 
	 */
	public static boolean downloadGoodsInfo(ArrayList<Integer> gids) throws JSONException {
		retData = new JSONObject();
		BasicDBObject obj = new BasicDBObject(Goods.GID, new BasicDBObject("$in", gids));
		DBCursor cursor = DBController.query(Goods.COLLNAME, obj);
		JSONObject ret = new JSONObject();
		while (cursor.hasNext()) {
			DBObject retObj = cursor.next();
			ret.put(retObj.get(Goods.GID).toString(), retObj);
		}
		retData.put(HttpData.SUC, true);
		retData.put(HttpData.DATA, ret);
		return true;
	}
	
	/**
	 * 下载goodsline
	 * @param seq
	 * @return
	 * @throws JSONException
	 */
	public static boolean downloadGoodsLine(int seq) throws JSONException {
		retData = new JSONObject();
		BasicDBObject obj1 = new BasicDBObject(GoodsLine.UID, 0);
		int[] range = {0, 10000};
		BasicDBObject obj2 = new BasicDBObject(GoodsLine.LIST, new BasicDBObject("$slice", range));
		DBObject retObj = DBController.queryOne(GoodsLine.COLLNAME, obj1, obj2);
		if (retObj == null) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		retData.put(HttpData.SUC, true);
		int seq0 = Integer.parseInt(retObj.get(GoodsLine.SEQ).toString());
		if (seq == seq0) {
			retData.put(HttpData.INFO, "newest");
			return true;
		}
		JSONObject data = new JSONObject();
		data.put("seq", seq0);
		BasicDBList retList = (BasicDBList) retObj.get(GoodsLine.LIST);
		int len = retList.size();
		if (len > seq0 - seq + 100)
			data.put("gids", retList.subList(0, seq0 - seq + 100));
		else
			data.put("gids", retList);
			retData.put(HttpData.DATA, data);	
		return true;
	}
	
	private static boolean addToGoodsLine(int gid) {
		BasicDBObject oldObj = new BasicDBObject(GoodsLine.UID, 0);
		BasicDBObject newObj = new BasicDBObject();
		newObj.put("$push", new BasicDBObject(GoodsLine.LIST, gid));
		newObj.put("$inc", new BasicDBObject(GoodsLine.SEQ, 1));
		DBController.update(GoodsLine.COLLNAME, oldObj, newObj, true, false);
		return true;
	}
	
	/**
	 * 创建gid，每个商品一个gid
	 * @return
	 */
	private static int createGid() {
		BasicDBObject oldObj = new BasicDBObject();
		oldObj.put(IDCounter.KEY, IDCounter.GID);
		BasicDBObject newObj = new BasicDBObject();
		newObj.put("$inc", new BasicDBObject().append(IDCounter.VALUE, 1));
		if (!DBController.update(IDCounter.COLLNAME, oldObj, newObj, true, false))
			return -1;
		DBCursor cursor = DBController.query(IDCounter.COLLNAME, oldObj);
		if (!cursor.hasNext())
			return -1;
		return (Integer) cursor.next().get(IDCounter.VALUE);
	}
}
