package cn.edu.hit.Dao;

import java.net.UnknownHostException;

import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCursor;
import com.mongodb.Mongo;

public class DBController {
	private static Mongo mg;
	private static DB db;
//	private static boolean isConnect = false;
	private static String username = "hitren";
	private static String password = "ilovehit123";
	private static String dbname = "HITRenDB";
	static {
//		if (isConnect)
//			return;
		
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
//			return;
	}
//	public boolean connectTo(String name) throws UnknownHostException {
//		
//	}
	public static DBCursor query(String collname,BasicDBObject obj) {
		return db.getCollection(collname).find(obj);
	}
}
