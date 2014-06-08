package cn.edu.hit.servlet.trade;

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
import cn.edu.hit.logic.TradeLogic;
import cn.edu.hit.servlet.kit.BaseServlet;

/**
 * Servlet implementation class DownloadMyGoodsServlet
 * 参数uid, seq
 */
@WebServlet("/DownloadMyGoodsServlet")
public class DownloadMyGoodsServlet extends BaseServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DownloadMyGoodsServlet() {
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
		logger.info(data);
		try {
			JSONObject json = new JSONObject(data);
			int uid = json.getInt("uid");
			int seq = json.getInt("seq");
			JSONObject retData = TradeLogic.downloadMyGoods(uid, seq);
			response.setCharacterEncoding("utf-8");
			PrintWriter out = response.getWriter();
			out.print(retData);
			logger.info(retData);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
