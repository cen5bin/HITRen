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

/**
 * Servlet implementation class DownloadCommentListServlet
 * 参数，datas,数组，每个元素为一个json，包含seq和mid两个键，每条状态最多返回末尾的20条状态
 */
@WebServlet("/DownloadCommentListServlet")
public class DownloadCommentListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DownloadCommentListServlet() {
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
			JSONArray datas0 = json.getJSONArray("datas");
			ArrayList<JSONObject> datas = new ArrayList<JSONObject>();
			for (int i = 0; i < datas0.length(); i++)
				datas.add(datas0.getJSONObject(i));
			
//			JSONArray mids0 = json.getJSONArray("mids");
//			ArrayList<Integer> mids = new ArrayList<Integer>();
//			for (int i = 0; i < mids0.length(); i++) 
//				mids.add(mids0.getInt(i));
			MessageLogic.downloadCommentList(datas);
			response.setCharacterEncoding("utf-8");
			PrintWriter out = response.getWriter();
			out.print(MessageLogic.retData);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
