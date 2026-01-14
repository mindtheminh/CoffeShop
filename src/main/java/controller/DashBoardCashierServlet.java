/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.List;

import dao.OrderDaoJdbc;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Array;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Comparator;
import model.OrderDto;
import service.OrderService;
import service.OrderServiceImpl;

/**
 *
 * @author Acer
 */
public class DashBoardCashierServlet extends HttpServlet {

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
            out.println("<title>Servlet HomeCashierServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet HomeCashierServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    private OrderDaoJdbc orderDao;

    private OrderService orderService;

    @Override
    public void init() throws ServletException {
        orderDao = new OrderDaoJdbc();
        orderService = new OrderServiceImpl();
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
//        processRequest(request, response);

        HttpSession session = request.getSession(false); // không tạo mới
        if (session == null || session.getAttribute("authUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy danh sách đơn hàng đang hoạt động
        List<OrderDto> orders = orderDao.getAllOrders();

        // Tính thống kê nhỏ hiển thị trên top dashboard
        int orderCount = (orders != null) ? orders.size() : 0;

        ZoneId systemZone = ZoneId.systemDefault();
        LocalDate today = LocalDate.now(systemZone);

        // Start/end của hôm nay theo múi giờ hệ thống
        OffsetDateTime startOfDay = today.atStartOfDay(systemZone).toOffsetDateTime();
        OffsetDateTime endOfDay = today.plusDays(1).atStartOfDay(systemZone).toOffsetDateTime();

        List<OrderDto> todayOrders = new ArrayList<>();
        BigDecimal totalRevenue = BigDecimal.ZERO;
        BigDecimal totalPendingRevenue = BigDecimal.ZERO;

        for (OrderDto o : orders) {
            if ("Completed".equals(o.getStatus()) && o.getCreatedAt() != null) {
                // Kiểm tra xem createdAt có nằm trong khoảng hôm nay không
                if (!o.getCreatedAt().isBefore(startOfDay) && o.getCreatedAt().isBefore(endOfDay)) {
                    todayOrders.add(o);

                    if (o.getPaymentAmount() != null) {
                        totalRevenue = totalRevenue.add(o.getPaymentAmount());
                    }
                }
            }
        }

        for (OrderDto o : orders) {
            if ("Pending".equals(o.getStatus()) && o.getCreatedAt() != null) {
                // Kiểm tra xem createdAt có nằm trong khoảng hôm nay không
                if (!o.getCreatedAt().isBefore(startOfDay) && o.getCreatedAt().isBefore(endOfDay)) {
                    todayOrders.add(o);

                    if (o.getPaymentAmount() != null) {
                        totalPendingRevenue = totalPendingRevenue.add(o.getPaymentAmount());
                    }
                }
            }
        }

        // Đơn hàng các loại
        // --- Lọc chỉ các đơn trong ngày hôm nay (giống phần tính doanh thu) ---
        List<OrderDto> todayOrdersOnly = new ArrayList<>();
        for (OrderDto o : orders) {
            if (o.getCreatedAt() != null
                    && !o.getCreatedAt().isBefore(startOfDay)
                    && o.getCreatedAt().isBefore(endOfDay)) {
                todayOrdersOnly.add(o);
            }
        }

// --- Đơn hàng các loại (chỉ tính trong ngày hôm nay) ---
        List<OrderDto> orderCompleted = orderService.getOrdersByStatus(todayOrdersOnly, "Completed");
        List<OrderDto> orderPending = orderService.getOrdersByStatus(todayOrdersOnly, "Pending");
        List<OrderDto> orderProcessing = orderService.getOrdersByStatus(todayOrdersOnly, "Processing");
        List<OrderDto> orderCancelled = orderService.getOrdersByStatus(todayOrdersOnly, "Cancelled");

// --- Đếm ---
        int orderCountToday = todayOrdersOnly.size();
        int orderCountCompleted = orderCompleted.size();
        int orderCountPending = orderPending.size();
        int orderCountProcessing = orderProcessing.size();
        int orderCountCancelled = orderCancelled.size();

        // Định dạng tiền tệ nếu cần
        BigDecimal total = totalRevenue.add(totalPendingRevenue);
        String totalString = String.format("%,.0f đ", total);
        String revenueString = String.format("%,.0f đ", totalRevenue);
        String totalPendingRevenueString = String.format("%,.0f đ", totalPendingRevenue);

        // --- Lấy params lọc ---
        String status = request.getParameter("status");
        String filterDateStr = request.getParameter("filterDate");

        // --- Filter theo trạng thái nếu có ---
        if (status != null && !status.isEmpty()) {
            orders = orderService.getOrdersByStatus(orders, status);
        }

        // --- Filter theo ngày nếu có ---
        if (filterDateStr != null && !filterDateStr.isEmpty()) {
            LocalDate filterDate = LocalDate.parse(filterDateStr);
            OffsetDateTime startOfFilter = filterDate.atStartOfDay(systemZone).toOffsetDateTime();
            OffsetDateTime endOfFilter = filterDate.plusDays(1).atStartOfDay(systemZone).toOffsetDateTime();

            List<OrderDto> ordersByDate = new ArrayList<>();
            for (OrderDto o1 : orders) {
                if (o1.getCreatedAt() != null
                        && !o1.getCreatedAt().isBefore(startOfFilter)
                        && o1.getCreatedAt().isBefore(endOfFilter)) {
                    ordersByDate.add(o1);
                }
            }
            orders = ordersByDate;
        }

        // --- Sắp xếp giảm dần theo createdAt ---
        orders.sort(Comparator.comparing(OrderDto::getCreatedAt).reversed());

        // --- Lấy 10 đơn gần nhất ---
        List<OrderDto> o = new ArrayList<>();
        int limit = Math.min(10, orders.size());
        for (int i = 0; i < limit; i++) {
            o.add(orders.get(i));
        }

        request.setAttribute("orders", o);
        request.setAttribute("orderCount", orderCountToday);
        request.setAttribute("revenueString", revenueString);
        request.setAttribute("orderCountCompleted", orderCountCompleted);
        request.setAttribute("orderCountPending", orderCountPending);
        request.setAttribute("orderCountProcessing", orderCountProcessing);
        request.setAttribute("orderCountCancelled", orderCountCancelled);
        request.setAttribute("totalPendingRevenue", totalPendingRevenueString);
        request.setAttribute("total", totalString);

        request.setAttribute("status", status);
        request.setAttribute("filterDate", filterDateStr);

        // Lấy tên user từ session (nếu có)
        if (session != null && session.getAttribute("userName") != null) {
            request.setAttribute("userName", session.getAttribute("userName"));
        }

        // Chuyển tiếp sang JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/dashboard/CashierDasbboard.jsp");
        dispatcher.forward(request, response);
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
// Lấy danh sách đơn hàng đang hoạt động
        List<OrderDto> orders = orderDao.getAllOrders();
        // Tính thống kê nhỏ hiển thị trên top dashboard
        int orderCount = (orders != null) ? orders.size() : 0;

        BigDecimal totalRevenue = BigDecimal.ZERO;
        for (OrderDto o : orders) {
            if (o.getPaymentAmount() != null) {
                totalRevenue = totalRevenue.add(o.getPaymentAmount());
            }
        }

        //Đơn hàng các loại
        List<OrderDto> orderCompleted = orderService.getOrdersByStatus(orders, "Completed");
        List<OrderDto> orderPending = orderService.getOrdersByStatus(orders, "Pending");
        List<OrderDto> orderProcessing = orderService.getOrdersByStatus(orders, "Processing");
        List<OrderDto> orderCancelled = orderService.getOrdersByStatus(orders, "Cancelled");

        int orderCountCompleted = (orderCompleted != null) ? orderCompleted.size() : 0;
        int orderCountPending = (orderPending != null) ? orderPending.size() : 0;
        int orderCountProcessing = (orderProcessing != null) ? orderProcessing.size() : 0;
        int orderCountCancelled = (orderCancelled != null) ? orderCancelled.size() : 0;

        // Định dạng tiền tệ nếu cần
        String revenueString = String.format("%,.0f đ", totalRevenue);

        List<OrderDto> o = new ArrayList<>();
        if (orders != null && !orders.isEmpty()) {
            int limit = Math.min(10, orders.size());
            for (int i = 0; i < limit; i++) {
                o.add(orders.get(i)); // Sửa lỗi ClassCastException ở đây
            }
        }

        // Gửi dữ liệu sang JSP
        request.setAttribute("orders", o);
        request.setAttribute("orderCount", orderCount);
        request.setAttribute("revenueString", revenueString);
        request.setAttribute("orderCountCompleted", orderCountCompleted);
        request.setAttribute("orderCountPending", orderCountPending);
        request.setAttribute("orderCountProcessing", orderCountProcessing);
        request.setAttribute("orderCountCancelled", orderCountCancelled);

        // Lấy tên user từ session (nếu có)
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userName") != null) {
            request.setAttribute("userName", session.getAttribute("userName"));
        }

        // Chuyển tiếp sang JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/dashboard/CashierDasbboard.jsp");
        dispatcher.forward(request, response);
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
