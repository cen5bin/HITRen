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