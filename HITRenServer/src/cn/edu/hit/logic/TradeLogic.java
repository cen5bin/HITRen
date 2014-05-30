package cn.edu.hit.logic;

import java.util.ArrayList;

import org.json.JSONException;
import org.json.JSONObject;

import cn.edu.hit.constant.Goods;
import cn.edu.hit.constant.HttpData;
import cn.edu.hit.constant.IDCounter;
import cn.edu.hit.dao.DBController;

import com.mongodb.BasicDBObject;
import com.mongodb.DBCursor;

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
		obj.put(Goods.GID, createGid());
		obj.put(Goods.NAME, name);
		obj.put(Goods.PRICE, price);
		obj.put(Goods.PICS, pics);
		obj.put(Goods.DESCRIPTION, desc);
		obj.put(Goods.UID, uid);
		if (!DBController.addObj(Goods.COLLNAME, obj)) {
			retData.put(HttpData.SUC, false);
			return false;
		}
		retData.put(HttpData.SUC, true);
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
