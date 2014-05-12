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
 * Servlet implementation class DownloadLikedListServlet
 * 参数，datas,一个数组，每个元素都是个json，包括两个键，mid和seq
 */
@WebServlet("/DownloadLikedListServlet")
public class DownloadLikedListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DownloadLikedListServlet() {
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
			MessageLogic.downloadLikedList(datas);
			response.setCharacterEncoding("utf-8");
			PrintWriter out = response.getWriter();
			out.print(MessageLogic.retData);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
