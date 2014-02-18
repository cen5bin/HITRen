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
import org.json.JSONException;
import org.json.JSONObject;

import cn.edu.hit.kit.DataKit;
import cn.edu.hit.logic.MessageLogic;
import cn.edu.hit.logic.RelationshipLogic;

/**
 * Servlet implementation class SendShortMessageServlet
 * 发短状态
 * 参数 uid， message， auth（可见范围，为0表示全部人可见，为1表示部分人可见），如果auth=1，还得发送gnames表示可见的分组
 */
@WebServlet("/SendShortMessageServlet")
public class SendShortMessageServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SendShortMessageServlet() {
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
			int auth = json.getInt("auth");
			String message = json.getString("message");
			ArrayList<String> gnames = new ArrayList<String>();
			if (auth == 1) {
				JSONArray gnames0 = json.getJSONArray("gnames");
				for (int i = 0; i < gnames0.length(); i++)
				gnames.add(gnames0.getString(i));
			}
			MessageLogic.sendShortMessage(uid, message, gnames);
			response.setCharacterEncoding("utf-8");
			PrintWriter out = response.getWriter();
			out.print(RelationshipLogic.retData);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
