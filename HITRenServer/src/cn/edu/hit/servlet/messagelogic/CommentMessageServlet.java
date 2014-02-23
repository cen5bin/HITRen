package cn.edu.hit.servlet.messagelogic;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import cn.edu.hit.kit.DataKit;
import cn.edu.hit.logic.MessageLogic;
import cn.edu.hit.logic.RelationshipLogic;

/**
 * Servlet implementation class CommentMessageServlet
 * 评论状态
 * 参数：uid,mid,type(0表示直接回复的状态，1表示回复某人的评论),如果type为1，则还有字段reuid表示被回复的uid。 content字段表示回复的内容
 */
@WebServlet("/CommentMessageServlet")
public class CommentMessageServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CommentMessageServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String data = DataKit.getDataFromClient(request.getReader());
		try {
			JSONObject json = new JSONObject(data);
			int uid = json.getInt("uid");
			int mid = json.getInt("mid");
			int type = json.getInt("type");
			String content = json.getString("content");
			int reuid = -1;
			if (type == 1)
				reuid = json.getInt("reuid");
			MessageLogic.commentMessage(uid, mid, reuid, content);
			response.setCharacterEncoding("utf-8");
			PrintWriter out = response.getWriter();
			out.print(RelationshipLogic.retData);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
