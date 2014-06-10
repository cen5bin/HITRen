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
 * Servlet implementation class SearchGoodsServlet
 */
@WebServlet("/SearchGoodsServlet")
public class SearchGoodsServlet extends BaseServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SearchGoodsServlet() {
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
			String info = json.getString("info");
			JSONObject retData = TradeLogic.searchGoods(info);
			response.setCharacterEncoding("utf-8");
			PrintWriter out = response.getWriter();
			out.print(retData);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
