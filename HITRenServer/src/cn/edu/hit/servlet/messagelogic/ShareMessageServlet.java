package cn.edu.hit.servlet.messagelogic;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;


import cn.edu.hit.kit.DataKit;
import cn.edu.hit.logic.MessageLogic;

/**
 * Servlet implementation class ShareMessageServlet
 * 分享状态
 * 参数： uid(分享者), mid(被分享的状态), content(分享时的描述), gnames(分享给这些分组的好友看)
 */
@WebServlet("/ShareMessageServlet")
public class ShareMessageServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ShareMessageServlet() {
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
			String content = json.getString("content");
			JSONArray gnames0 = json.getJSONArray("gnames");
			ArrayList<String> gnames = new ArrayList<String>();
			for (int i = 0; i < gnames0.length(); i++)
				gnames.add(gnames0.getString(i));
			MessageLogic.shareMessage(uid, mid, content, gnames);
			response.setCharacterEncoding("utf-8");
			PrintWriter out = response.getWriter();
			out.print(MessageLogic.retData);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
