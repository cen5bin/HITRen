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

class IDCounter {
	//表名
	protected static final String COLLNAME = "IDCounter";
	//列名
	protected static final String KEY = "key";
	protected static final String VALUE = "value";
	//key
	protected static final String UID = "uid";
}

class Relationship {
	protected static final String COLLNAME = "Relationship";
	protected static final String UID = "uid";
	protected static final String SEQ = "seq";
	protected static final String CONCERNLIST = "concernlist";
	protected static final String BLACKLIST = "blacklist";
	protected static final String GNAME = "gname";
	protected static final String USERLIST = "userlist";
}

class HttpData {
	protected static final String SUC = "SUC";
	protected static final String INFO = "INFO";
	protected static final String DATA = "DATA";
}