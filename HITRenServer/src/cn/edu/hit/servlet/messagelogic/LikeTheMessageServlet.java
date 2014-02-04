package cn.edu.hit.servlet.messagelogic;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import cn.edu.hit.logic.MessageLogic;

/**
 * Servlet implementation class LikeTheMessageServlet
 * 点赞
 * 参数uid（点赞者），mid（被点赞的状态）
 */
@WebServlet("/LikeTheMessageServlet")
public class LikeTheMessageServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LikeTheMessageServlet() {
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
		String data = request.getParameter("data");
		data = new String(data.getBytes("ISO8859_1"),"utf-8");
		try {
			JSONObject json = new JSONObject(data);
			int uid = json.getInt("uid");
			int mid = json.getInt("mid");
			MessageLogic.likeTheMessage(uid, mid);
			response.setCharacterEncoding("utf-8");
			PrintWriter out = response.getWriter();
			out.print(MessageLogic.retData);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
