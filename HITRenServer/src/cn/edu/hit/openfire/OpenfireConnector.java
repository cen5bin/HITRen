package cn.edu.hit.openfire;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

import org.jivesoftware.smack.Connection;
import org.jivesoftware.smack.ConnectionConfiguration;
import org.jivesoftware.smack.XMPPConnection;
import org.jivesoftware.smack.XMPPException;

import cn.edu.hit.kit.FileKit;

public class OpenfireConnector {
	private String confpath = FileKit.getConfPath()+"openfire.conf"; //this.getClass().getClassLoader().getResource("").getPath()+"/../conf/openfire.conf";
	
	// openfire服务器信息
	private static String IP;
	private static String hostname;
	private static int port;
	
	// openfire管理员账号
	private static String username;
	private static String password;
	
	private static ConnectionConfiguration config;
	private static Connection connection = null;
	private static Connection normalConnection = null;
	
	private static OpenfireConnector connector;
	
	private static OpenfireConnector sharedInstance() throws IOException {
		if (connector == null)
			connector = new OpenfireConnector();
		return connector;
	}

	/**
	 * 获取admin对openfire的连接
	 * @return	Connection 对象，该对象登录了admin账号，可以消息，创建用户等等
	 * @throws IOException
	 * @throws XMPPException
	 */
	public static Connection getAdminConnection() throws IOException, XMPPException {
		if (connection == null || !connection.isConnected()) {
			OpenfireConnector connector = OpenfireConnector.sharedInstance();
			connector.connectToOpenfire();
		}
		return connection;
	}
	
	/**
	 * 获取普通用户对openfire的链接
	 * @param username
	 * @param password
	 * @throws XMPPException
	 * @throws IOException 
	 */
	public static Connection getNormalConnection(String username, String password) throws XMPPException, IOException {
		if (normalConnection != null && normalConnection.isConnected())
			normalConnection.disconnect();
		OpenfireConnector connector = OpenfireConnector.sharedInstance();
		connector.connectToOpenfire(username, password);
		return normalConnection;
	}
	
	/**
	 * 返回域名
	 * @return 
	 * @throws XMPPException 
	 * @throws IOException 
	 */
	public static String getHostname() throws IOException, XMPPException {
		if (hostname == null)
			getAdminConnection();
		return hostname;
	}
	private OpenfireConnector() throws IOException {
		BufferedReader br = new BufferedReader(new FileReader(confpath));
		IP = br.readLine().split(":")[1].trim();
		hostname = br.readLine().split(":")[1].trim();
		port = Integer.parseInt(br.readLine().split(":")[1].trim());
		username = br.readLine().split(":")[1].trim();
		password = br.readLine().split(":")[1].trim();
		br.close();
		
		config = new ConnectionConfiguration(hostname, port, IP);
		config.setReconnectionAllowed(true);
		config.setCompressionEnabled(true);
		config.setSASLAuthenticationEnabled(true);
	}
	
	private void connectToOpenfire() throws XMPPException {
		connection = new XMPPConnection(config);
		connection.connect();
		connection.login(username, password);
	}
	
	private void connectToOpenfire(String username, String password) throws XMPPException {
		ConnectionConfiguration config = new ConnectionConfiguration(hostname, port, IP);
		config.setCompressionEnabled(true);
		config.setSASLAuthenticationEnabled(true);
		normalConnection = new XMPPConnection(config);
		normalConnection.connect();
		normalConnection.login(username, password);
	}
}
