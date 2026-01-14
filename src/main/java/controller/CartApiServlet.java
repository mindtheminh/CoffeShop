package controller;

import dao.CartDao;
import dao.CartDaoJdbc;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import model.OrderItem;
import model.UserDto;

import java.io.IOException;
import java.util.List;

/**
 * CartApiServlet - API endpoints for cart operations
 * Provides JSON responses for AJAX requests
 */
public class CartApiServlet extends HttpServlet {

    private CartDao cartDao;

    @Override
    public void init() throws ServletException {
        cartDao = new CartDaoJdbc();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo();

        // Set response type to JSON
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        if ("/count".equals(pathInfo)) {
            // Get cart item count
            getCartCount(req, resp);
        } else {
            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            resp.getWriter().write("{\"error\": \"Endpoint not found\"}");
        }
    }

    /**
     * Get cart item count for current user
     */
    private void getCartCount(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession(false);
        
        // If no session or not logged in, return 0
        if (session == null) {
            resp.getWriter().write("{\"count\": 0}");
            return;
        }

        UserDto authUser = (UserDto) session.getAttribute("authUser");
        if (authUser == null) {
            resp.getWriter().write("{\"count\": 0}");
            return;
        }

        try {
            int userId = Integer.parseInt(authUser.getUserId());

            // Get cart
            Order cart = cartDao.findOrCreateCart(userId);

            // Get cart items
            List<OrderItem> cartItems = cartDao.getCartItems(cart.getOrderId());

            // Return total quantity (sum of all item quantities)
            int count = cartItems.stream().mapToInt(OrderItem::getQuantity).sum();
            resp.getWriter().write("{\"count\": " + count + "}");

        } catch (Exception e) {
            System.err.println("Error getting cart count: " + e.getMessage());
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\": \"Internal server error\", \"count\": 0}");
        }
    }
}

