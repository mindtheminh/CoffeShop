package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import common.UserRole;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest r = (HttpServletRequest) req;
        HttpServletResponse p = (HttpServletResponse) res;

        String ctx = r.getContextPath();
        String path = r.getRequestURI().substring(ctx.length());

        // Allow public routes and static assets
        if (isPublic(path)) {
            chain.doFilter(req, res);
            return;
        }

        HttpSession session = r.getSession(false);
        
        // Check if user is logged in (support both authUser and loggedUser)
        Object authUser = session != null ? session.getAttribute("authUser") : null;
        Object loggedUser = session != null ? session.getAttribute("loggedUser") : null;
        Object userRole = session != null ? session.getAttribute("userRole") : null;
        
        // If no user session, redirect to login
        if (session == null || (authUser == null && loggedUser == null && userRole == null)) {
            p.sendRedirect(ctx + "/auth/login");
            return;
        }

        // Get role from various sources
        String role = null;
        if (userRole != null) {
            role = (String) userRole;
        } else if (authUser instanceof model.UserDto) {
            role = ((model.UserDto) authUser).getRole();
        } else if (loggedUser instanceof model.UserDto) {
            role = ((model.UserDto) loggedUser).getRole();
        }

        // Customer area: allow if user is logged in (even without role)
        if (path.startsWith("/customer") || path.startsWith("/api/cart")) {
            if (authUser != null || loggedUser != null) {
                chain.doFilter(req, res);
                return;
            } else {
                p.sendRedirect(ctx + "/auth/login");
                return;
            }
        }

        // For other protected areas, require role
        if (role == null) {
            p.sendRedirect(ctx + "/auth/login");
            return;
        }

        // Guard by area
        if (isAdminArea(path) && !UserRole.ADMIN.equals(role)) {
            forwardDenied(r, p);
            return;
        }
        if (isMarketerArea(path) && !(UserRole.MARKETER.equals(role) || UserRole.ADMIN.equals(role))) {
            forwardDenied(r, p);
            return;
        }
        if (isHRArea(path) && !(UserRole.HR.equals(role) || UserRole.ADMIN.equals(role))) {
            forwardDenied(r, p);
            return;
        }
        if (isCashierArea(path) && !(UserRole.CASHIER.equals(role) || UserRole.ADMIN.equals(role))) {
            forwardDenied(r, p);
            return;
        }

        chain.doFilter(req, res);
    }

    private boolean isPublic(String path) {
        return path.equals("/")
                || path.startsWith("/home")
                || path.startsWith("/auth")
                || path.startsWith("/assets")
                || path.startsWith("/images")
                || path.startsWith("/css")
                || path.startsWith("/js")
                || path.equals("/public-product-details")
                || path.startsWith("/public-product-details");  // Public product details page
    }

    private boolean isAdminArea(String path) {
        return path.equals("/admin-dashboard") || path.startsWith("/setting");
    }

    private boolean isMarketerArea(String path) {
        // Only protect product management pages
        return path.equals("/marketer-dashboard") 
                || path.equals("/product-detail") 
                || path.startsWith("/product-detail") 
                || path.equals("/product-list") 
                || path.startsWith("/product-list")
                || path.equals("/product-new")
                || path.equals("/product-edit")
                || path.equals("/promotion-list") 
                || path.startsWith("/promotion-list")
                || path.equals("/promotion-new")
                || path.equals("/promotion-detail")
                || path.startsWith("/promotion-detail");
    }

    private boolean isHRArea(String path) {
        return path.equals("/hr-dashboard") || path.startsWith("/user");
    }

    private boolean isCashierArea(String path) {
        return path.equals("/cashier-dashboard") || path.equals("/sales-dashboard") || path.startsWith("/order");
    }

    private void forwardDenied(HttpServletRequest r, HttpServletResponse p) throws ServletException, IOException {
        r.getRequestDispatcher("/WEB-INF/view/common/access-denied.jsp").forward(r, p);
    }
}
//
//package filter;
//
//import jakarta.servlet.*;
//import jakarta.servlet.annotation.WebFilter;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import java.io.IOException;
//import java.util.Set;
//
//@WebFilter(filterName = "AuthFilter", urlPatterns = {"/*"})
//public class AuthFilter implements Filter {
//
//    private static final Set<String> PUBLIC = Set.of(
//            "/", "/home", "/auth", "/assets", "/css", "/js", "/img", "/images", "/vendor"
//    );
//    private static final Set<String> PROTECTED = Set.of(
//            "/admin", "/order" // thêm "/product" nếu muốn hạn chế tạo/sửa/xóa
//    );
//
//    @Override
//    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
//            throws IOException, ServletException {
//
//        HttpServletRequest r = (HttpServletRequest) req;
//        HttpServletResponse p = (HttpServletResponse) res;
//        String ctx = r.getContextPath();
//        String path = r.getRequestURI().substring(ctx.length());
//
//        if (startsWith(path, PUBLIC)) {
//            chain.doFilter(req, res);
//            return;
//        }
//        if (startsWith(path, PROTECTED)) {
//            if (r.getSession(false) == null || r.getSession(false).getAttribute("authUser") == null) {
//                p.sendRedirect(ctx + "/auth/login");
//                return;
//            }
//        }
//        chain.doFilter(req, res);
//    }
//
//    private boolean startsWith(String path, Set<String> prefixes) {
//        for (String pre : prefixes) {
//            if (path.equals(pre) || path.startsWith(pre + "/")) return true;
//        }
//        return false;
//    }
//}
