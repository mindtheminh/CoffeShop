/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import dao.OrderDao;
import dao.OrderDaoJdbc;
import dao.OrderItemDao;
import dao.ProductDao;
import dao.ProductDaoJdbc;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import model.OrderItem;
import model.ProductDto;
import model.UserDto;
import service.OrderIteamService;

/**
 *
 * @author Acer
 */
public class NewOrderServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet NewOrderServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet NewOrderServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        int userId = 0;

        if (session != null) {
            UserDto authUser = (UserDto) session.getAttribute("authUser");
            if (authUser != null && authUser.getUserId() != null) {
                try {
                    userId = Integer.parseInt(authUser.getUserId());
                } catch (NumberFormatException e) {
                    e.printStackTrace(); // hoặc xử lý khác
                }
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }

        // 1) Lấy danh sách sản phẩm
        ProductDaoJdbc productDao = new ProductDaoJdbc();
        List<ProductDto> productList = productDao.getAllProductsActive();

        // 2) Khởi tạo order mới
        Order newOrder = new Order();
        newOrder.setUserId(1); // hoặc lấy từ session user hiện tại
        newOrder.setStatus("Pending");
        newOrder.setTotalAmount(BigDecimal.ZERO);
        newOrder.setDiscountAmount(BigDecimal.ZERO);
        newOrder.setCart(false); // order thật
        newOrder.setOrderType("Dine-in"); // default nếu cần

        // 3) Lưu DB thông qua DAO mới
        OrderDaoJdbc orderDao = new OrderDaoJdbc();
        String newOrderId = orderDao.create(newOrder, userId); // DAO đã set orderId vào entity

        // 4) Gán lại ID cho request và session
        request.setAttribute("orderId", newOrderId);
        request.setAttribute("currentOrder", newOrder);

        // 5) Truyền product list sang JSP
        request.setAttribute("productList", productList);

        //Check
        if (session != null && session.getAttribute("userName") != null) {
            request.setAttribute("userName", session.getAttribute("userName"));
        }

        // 6) Forward sang giao diện
        request.getRequestDispatcher("/WEB-INF/view/order/OrderCashier.jsp")
                .forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
//        processRequest(request, response);
        String note = request.getParameter("note");
        System.out.println("note gửi: " + note);

        String productID = request.getParameter("productId");
        String quanityStr = request.getParameter("quantity");
        String currenOrderId = request.getParameter("orderId");

        int quanity = 0;
        String errorMessage = null;
        try {
            quanity = Integer.parseInt(quanityStr);
            if (quanity <= 0) {
                errorMessage = "Không được thêm số lượng âm";

            }
        } catch (NumberFormatException e) {
            errorMessage = "vui lòng nhập số";
        }

        if (errorMessage != null && errorMessage.isEmpty()) {
            request.setAttribute("errorMessage", errorMessage);
            response.sendRedirect(request.getContextPath() + "/NewOrderServlet");
            return;
        }

        //Lấy sản phẩm được thêm
        ProductDao pro = new ProductDaoJdbc();
        ProductDto product = pro.findById(productID);

        if (errorMessage != null) {
            //trả menu

            //note
            OrderDao orderDao = new OrderDaoJdbc();
            Order updatedOrder = orderDao.findById(currenOrderId).orElseThrow();
            if (note != null) {
                StringBuilder noteStr = new StringBuilder();
                if (updatedOrder.getNote() != null) {
                    noteStr.append(updatedOrder.getNote());
                    noteStr.append(" ");
                }

                noteStr.append(note);

                orderDao.updateNote(currenOrderId, noteStr.toString());
                updatedOrder.setNote(noteStr.toString());
            }

            List<ProductDto> productList = new ArrayList<>();
            ProductDaoJdbc p = new ProductDaoJdbc();
            productList = p.getAllProductsActive();

            OrderItemDao orderItemDao = new OrderItemDao();
            request.setAttribute("errorMessage", errorMessage);
            request.setAttribute("errorProductId", productID);

            //trả đơn
            List<OrderItem> orderItems = OrderItemDao.getOrderItemsByOrderId(currenOrderId);

            request.setAttribute("orderItems", orderItems);
            request.setAttribute("productList", productList);
            request.setAttribute("orderId", currenOrderId);
            request.setAttribute("pendingOrder", updatedOrder);
            request.getRequestDispatcher("/WEB-INF/view/order/OrderCashier.jsp").forward(request, response);
            return;
        } else {
            OrderDao orderDao = new OrderDaoJdbc();
            Order updatedOrder = orderDao.findById(currenOrderId).orElseThrow();

            //add note và orderItem ở truong jhop  co ỏder
            if (note != null) {
                StringBuilder noteStr = new StringBuilder();
               if (updatedOrder.getNote() != null) {
                    noteStr.append(updatedOrder.getNote());
                    noteStr.append(" ");
                }
                noteStr.append(note);

                orderDao.updateNote(currenOrderId, noteStr.toString());
                updatedOrder.setNote(noteStr.toString());
            }
//            //tạo đơn sản phẩm 
            OrderItem orderItem = new OrderItem();
            orderItem.setOrderId(currenOrderId);
            orderItem.setProductId(productID);
            orderItem.setQuantity(quanity);
            orderItem.setUnitPrice(product.getPrice());
            orderItem.setSubtotal(product.getPrice().multiply(new BigDecimal(quanity)));

            // Lưu vào DB đơn hàng của khách
            OrderItemDao orderItemDao = new OrderItemDao();
            OrderIteamService service = new OrderIteamService();
            service.addOrderItemToOrderOffline(orderItem, currenOrderId);

            // Lấy đơn hàng + list items 
            List<OrderItem> orderItems = OrderItemDao.getOrderItemsByOrderId(currenOrderId);

            //load lại tổng tiền order
            updatedOrder = orderDao.findById(currenOrderId).orElseThrow();

            request.setAttribute("pendingOrder", updatedOrder);
            request.setAttribute("orderItems", orderItems);
            request.setAttribute("orderId", currenOrderId); //form add lần nữa

            // lấy danh sách sản phẩm so sanh ở
            List<ProductDto> productList = new ArrayList<>();
            ProductDaoJdbc p = new ProductDaoJdbc();
            productList = p.getAllProductsActive();

            request.setAttribute("productList", productList);

            request.getRequestDispatcher("/WEB-INF/view/order/OrderCashier.jsp").forward(request, response);
        }

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
