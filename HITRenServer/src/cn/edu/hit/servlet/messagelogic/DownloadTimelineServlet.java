package cn.edu.hit.servlet.messagelogic;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONException;
import org.json.JSONObject;

import cn.edu.hit.kit.DataKit;
import cn.edu.hit.logic.MessageLogic;

/**
 * Servlet implementation class DownloadTimelineServlet
 * 参数 seq，timeline的序列号
 */
@WebServlet("/DownloadTimelineServlet")
public class DownloadTimelineServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DownloadTimelineServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		try {
			MessageLogic.downloadTimeline(10);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String data = DataKit.getDataFromClient(request.getReader());
		try {
			JSONObject json = new JSONObject(data);
			int seq = json.getInt("seq");
			MessageLogic.downloadTimeline(seq);
			response.setCharacterEncoding("utf-8");
			PrintWriter out = response.getWriter();
			out.print(MessageLogic.retData);
			
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
