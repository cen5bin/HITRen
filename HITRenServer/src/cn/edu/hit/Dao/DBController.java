package cn.edu.hit.Dao;

import java.net.UnknownHostException;

import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCursor;
import com.mongodb.Mongo;
import com.mongodb.WriteResult;

public class DBController {
	private static Mongo mg;
	private static DB db;
	private static String username = "hitren";
	private static String password = "ilovehit123";
	private static String dbname = "HITRenDB";
	static {
		try {
			mg = new Mongo();
		} catch (UnknownHostException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		db = mg.getDB(dbname);
		boolean ret = db.authenticate(username, password.toCharArray());
		if (!ret)
			System.out.print("auth error\n");
		else
			System.out.print("connect succ!");
	}

	public static DBCursor query(String collname, BasicDBObject obj) {
		return db.getCollection(collname).find(obj);
	}

	public static boolean objExits(String collname, BasicDBObject obj) {
		DBCursor cursor = DBController.query(collname, obj);
		return cursor.hasNext();
	}
	public static boolean addObj(String collname, BasicDBObject obj) {
		WriteResult wr = db.getCollection(collname).save(obj);
		return true;
//		System.out.print(wr.getN());
//		db.getCollection(collname)
//		if (wr != null && wr.getN() > 0)
//			return true;
//		return false;
	}

	public static boolean update(String collname, BasicDBObject oldObj, BasicDBObject newObj) {
		WriteResult wr = db.getCollection(collname).update(oldObj, newObj);
		if (wr != null && wr.getN() > 0)
			return true;
		return false;
	}

	public static boolean update(String collname, BasicDBObject oldObj, BasicDBObject newObj,
			boolean upsert, boolean multi) {
		 WriteResult wr = db.getCollection(collname).update(oldObj, newObj, upsert, multi);
		 if (wr != null && wr.getN() > 0)
				return true;
			return false;
	}
	
}