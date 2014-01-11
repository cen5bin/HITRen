package cn.edu.hit.openfire;

import java.io.IOException;

import org.jivesoftware.smack.Chat;
import org.jivesoftware.smack.MessageListener;
import org.jivesoftware.smack.XMPPException;
import org.jivesoftware.smack.packet.Message;


public class MessagePusher {
	
	/**
	 * 状态被点赞时发推送消息给该用户
	 * @param uid 被点赞的用户id
	 * @param uid1 去点赞的用户id
	 * @throws XMPPException 
	 * @throws IOException 
	 */
	public static void MessageIsLikedByUser(int uid, int uid1) throws IOException, XMPPException {
		MessagePusher.sendMessage("tt@127.0.0.1", "asd");
	}
	
	private static void sendMessage(String user, String message) throws IOException, XMPPException {
		Chat chat = OpenfireConnector.getAdminConnection().getChatManager().createChat(user, new MessageListener() {
			@Override
			public void processMessage(Chat arg0, Message arg1) {
				// TODO Auto-generated method stub
			}
		});
		chat.sendMessage(message);
	}
	
	
}
