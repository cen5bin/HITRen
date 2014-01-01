package cn.edu.hit.Dao;

public enum Constant {
//	EMAIL("email"),
//	PASSWORD("password");
//	private final String value;
//	public String getValue() {
//		return value;
//	}
//	Constant(String value) {
//		this.value = value;
//	}
}

class UserConstant {
	//数据库表名
	protected static final String COLLNAME = "User"; 

	//字段名
	protected static final String UID = "uid";
	protected static final String EMAIL = "email";
	protected static final String PASSWORD = "password";
	protected static final String SEQ = "seq";
}

class Message {
	protected static final String COLLNAME = "Message";
	
	protected static final String MID = "mid";
	protected static final String UID = UserConstant.UID;
	protected static final String TIME = "time";
	protected static final String COMMENTLIST = "commentlist";
	protected static final String LIKEDLIST = "likedlist";
	protected static final String SHATECOUNT = "sharedcount";
	protected static final String TYPE = "type";
	protected static final class Type {
		protected static final int NORMAL = 0;
		protected static final int SHARED = 1;
	}
	protected static final String CONTENT = "content";
}

class IDCounter {
	//表名
	protected static final String COLLNAME = "IDCounter";
	//列名
	protected static final String KEY = "key";
	protected static final String VALUE = "value";
	//key
	protected static final String UID = UserConstant.UID;
	protected static final String MID = Message.MID;
}

class Relationship {
	protected static final String COLLNAME = "Relationship";
	protected static final String UID = UserConstant.UID;
	protected static final String SEQ = "seq";
	protected static final String CONCERNLIST = "concernlist";
	protected static final String BLACKLIST = "blacklist";
	protected static final String FOLLOWLIST = "followlist";
	
	//以下两个字段是在concernlist数组中每个元素的内部字段
	protected static final String GNAME = "gname";
	protected static final String USERLIST = "userlist";
	
	protected static final String DEFAULT = "default";
}

class TimeLine {
	protected static String COLLNAME = "TimeLine";
	protected static String UID = UserConstant.UID;
	protected static String LIST = "list";
}

class HttpData {
	protected static final String SUC = "SUC";
	protected static final String INFO = "INFO";
	protected static final String DATA = "DATA";
}