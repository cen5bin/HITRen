package cn.edu.hit.Dao;

import com.mongodb.BasicDBObject;
import com.mongodb.DBCursor;


public class UserSimpleLogic {
	
	public static boolean Login(String email, String password) {
		BasicDBObject obj = new BasicDBObject();
		obj.put(UserConstant.EMAIL, email);
		obj.put(UserConstant.PASSWORD, password);
		DBCursor cursor = DBController.query(UserConstant.COLLNAME, obj);
		return cursor.hasNext();
	}
	
}
