package com.bqa.servlet;

import com.bqa.model.Cart;
import com.bqa.model.CartItem;
import com.bqa.model.Product;
import com.bqa.model.User;
// import com.bqa.service.CartService; // Commented out due to missing file
import com.bqa.service.CartService;
import com.bqa.service.productServiece;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * CartServlet handles all shopping cart operations for customers
 */
@WebServlet("/cart/*")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
     private CartService cartService; // Commented out due to missing file
    private  productServiece productServiece;

    public void init() {
        cartService = new CartService(); // Commented out due to missing file
        productServiece = new productServiece();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();
        if (action == null) {
            action = "/view";
        }

        try {
            switch (action) {
                case "/add":
                    addToCart(request, response);
                    break;
                case "/update":
                    updateCart(request, response);
                    break;
                case "/remove":
                    removeFromCart(request, response);
                    break;
                case "/clear":
                    clearCart(request, response);
                    break;
                case "/apply-coupon":
                    applyCoupon(request, response);
                    break;
                default:
                    viewCart(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void viewCart(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        Cart cart; // This will be the cart object we work with and store in session

        if (user != null && user.getUserId() > 0) {
            // User is logged in. Load or create their cart.
            // This method should return a Cart object, ideally with its items loaded,
            // or at least with a correct cartId to load items.
            cart = cartService.getOrCreateCart(user.getUserId());
            
            if (cart != null && cart.getCartId() > 0) {
                // If getOrCreateCart doesn't populate items, or if items need to be explicitly fetched/refreshed.
                // Assuming Cart class has a setItems method or CartService populates it.
                List<CartItem> itemsFromDb = cartService.getCartItems(cart.getCartId());
                cart.setItems(itemsFromDb); // Ensure the cart object has its items.
            } else if (cart == null) {
                // Fallback if getOrCreateCart returns null (should be handled by the service)
                System.err.println("Warning: cartService.getOrCreateCart returned null for userId: " + user.getUserId());
                cart = new Cart();
                cart.setUserId(user.getUserId());
                // Potentially: cartService.saveCart(cart); // to persist and get a cartId
            }
            session.setAttribute("cart", cart); // Update session with the user's cart
        } else {
            // User is not logged in (anonymous user) or user ID is invalid
            cart = (Cart) session.getAttribute("cart");
            if (cart == null) {
                cart = new Cart(); // New anonymous cart
                session.setAttribute("cart", cart);
            }
        }

        // Now, 'cart' is the definitive cart object in session.
        // Its items list (cart.getItems()) should be the source of truth.
        List<CartItem> cart_items_for_jsp = cart.getItems();
        if (cart_items_for_jsp == null) { // Defensive null check
            cart_items_for_jsp = new ArrayList<>();
        }

        List<Product> products_for_jsp = new ArrayList<>();
        // The 'variant' list here will only contain variants for the *last* item in the loop.
        // This logic might need review if each product's variants need to be displayed.
        List<Map<String, String>> variants_for_jsp = new ArrayList<>(); 

        for (CartItem item : cart_items_for_jsp) {
            Product product = productServiece.getProductById(item.getProductId());
            if (product != null) {
                products_for_jsp.add(product);
                // This overwrites variants_for_jsp in each iteration:
                variants_for_jsp = productServiece.getProductVariantById(product.getProductId()); 
            }
        }
        
        // Calculate cart totals using items from the cart object
        BigDecimal subtotalDecimal = BigDecimal.ZERO;
        if (cart.getItems() != null) {
            for (CartItem item : cart.getItems()) {
                if (item.getPrice() != null && item.getQuantity() > 0) {
                    subtotalDecimal = subtotalDecimal.add(item.getPrice().multiply(new BigDecimal(item.getQuantity())));
                }
            }
        }

        double shipping = calculateShipping(cart); // Assuming calculateShipping(cart) works
        double total = subtotalDecimal.doubleValue() ;

        // Set attributes for JSP
        request.setAttribute("cart", cart); // The main cart object
        request.setAttribute("cart_items", cart_items_for_jsp); // The list of items from the cart
        request.setAttribute("products", products_for_jsp);     // Corresponding product details
        request.setAttribute("variant", variants_for_jsp);    // Variant details (with noted issue)

        // Attributes for the summary section in cart.jsp
        request.setAttribute("cartTotal", subtotalDecimal); // Maps to ${cartTotal}
        request.setAttribute("finalTotal", total);          // Maps to ${finalTotal}
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/cart.jsp");
        dispatcher.forward(request, response);
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {


        int productId = Integer.parseInt(request.getParameter("productId"));
        int variantId = Integer.parseInt(request.getParameter("variantId"));
        int quantity = 1;

        if (request.getParameter("quantity") != null) {
            quantity = Integer.parseInt(request.getParameter("quantity"));
        }

        if (quantity <= 0) {
            quantity = 1;
        }

        Product product = productServiece.getProductById(productId);

        if (product == null || !product.isActive()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }
        product.setStock(productServiece.getallVacantProductsWithid(product.getProductId()));

        // Get cart from session or create new one
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        //kiểm tra số lượng sản phẩm
        boolean productExists = false;
        for (CartItem item : cart.getItems()) {
            if (item.getProductId() == productId) {

                int newQuantity = item.getQuantity() + quantity;

                if (product.getStock() < newQuantity) {
                    session.setAttribute("error", "Số lượng sản phẩm không đủ. Chỉ còn " + product.getStock() + " sản phẩm.");
                    response.sendRedirect(request.getContextPath() + "/products/detail?id=" + productId);
                    return;
                }

                item.setQuantity(newQuantity);
                productExists = true;
                break;
            }
        }

        if (!productExists) {
            CartItem item = new CartItem();
            item.setProductId(productId);
            item.setProductName(product.getName());
            item.setPrice(product.getPrice());
            item.setVariantId(variantId);
            item.setQuantity(quantity);
            item.setProductImage(product.getThumbnail());

            cart.getItems().add(item);
        }


        User user = (User) session.getAttribute("user");
         if (user != null) {
             cart.setUserId(user.getUserId());
             cartService.saveCart(cart);
             response.sendRedirect(request.getContextPath() + "/cart");
         }

    }

    private void updateCart(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        // Get cart from session
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null || cart.getItems().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Get product IDs and quantities
        String[] productIds = request.getParameterValues("productId");
        String[] quantities = request.getParameterValues("quantity");

        if (productIds == null || quantities == null || productIds.length != quantities.length) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Update cart items
        List<CartItem> updatedItems = new ArrayList<>();
        for (int i = 0; i < productIds.length; i++) {
            int productId = Integer.parseInt(productIds[i]);
            int quantity = Integer.parseInt(quantities[i]);

            // Skip if quantity is 0 or negative
            if (quantity <= 0) {
                continue;
            }

            // Check product stock
            Product product = productServiece.getProductById(productId);
            if (product == null || !product.isActive()) {
                continue;
            }

            if (product.getStock() < quantity) {
                session.setAttribute("error", "Số lượng sản phẩm " + product.getName() + " không đủ. Chỉ còn " + product.getStock() + " sản phẩm.");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            // Find and update cart item
            for (CartItem item : cart.getItems()) {
                if (item.getProductId() == productId) {
                    item.setQuantity(quantity);
                    updatedItems.add(item);
                    break;
                }
            }
        }

        // Replace cart items with updated ones
        cart.setItems(updatedItems);

        // Save cart to database if user is logged in
        User user = (User) session.getAttribute("user");
         if (user != null) { // Commented out due to missing CartService
             cart.setUserId(user.getUserId());
             cartService.saveCart(cart);
         }

        // Set success message
        session.setAttribute("message", "Giỏ hàng đã được cập nhật");

        // Redirect to cart
        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        // Get product ID
        int productId = Integer.parseInt(request.getParameter("itemId"));

        // Get cart from session
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Remove item from cart
        List<CartItem> updatedItems = new ArrayList<>();
        for (CartItem item : cart.getItems()) {
            if (item.getProductId() != productId) {
                updatedItems.add(item);
            }
        }

        // Update cart
        cart.setItems(updatedItems);

        // Save cart to database if user is logged in
        User user = (User) session.getAttribute("user");
        if (user != null && cartService != null) {
            cart.setUserId(user.getUserId());
            System.out.println(productId);
            cartService.removeCartItem(productId,cart.getCartId());
        }

        // Redirect to cart
        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private void clearCart(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        // Get cart from session
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Clear cart
        cart.getItems().clear();

        // Save empty cart to database if user is logged in
        User user = (User) session.getAttribute("user");
         if (user != null) { // Commented out due to missing CartService
             cart.setUserId(user.getUserId());
             cartService.saveCart(cart);
         }

        // Redirect to cart
        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private void applyCoupon(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        // Get coupon code
        String code = request.getParameter("code");

        if (code == null || code.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Get cart from session
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null || cart.getItems().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Calculate cart subtotal
        BigDecimal couponSubtotalDecimal = BigDecimal.ZERO;
        for (CartItem item : cart.getItems()) {
            couponSubtotalDecimal = couponSubtotalDecimal.add(item.getPrice().multiply(new BigDecimal(item.getQuantity())));
        }

        // Apply promotion code
        // try { // Commented out due to missing CartService
        //     double discountAmount = cartService.applyPromotionCode(code, couponSubtotalDecimal, cart);
        //
        //     if (discountAmount > 0) {
        //         cart.setDiscount(discountAmount);
        //         cart.setPromotionCode(code);
        //
        //         // Save cart to database if user is logged in
        //         User user = (User) session.getAttribute("user");
        //         if (user != null) {
        //             cart.setUserId(user.getUserId());
        //             cartService.saveCart(cart);
        //         }
        //
        //         session.setAttribute("message", "Mã khuyến mãi đã được áp dụng");
        //     } else {
        //         session.setAttribute("error", "Mã khuyến mãi không hợp lệ hoặc đã hết hạn");
        //     }
        // } catch (Exception e) {
        //     session.setAttribute("error", e.getMessage());
        // }

        // Redirect to cart
        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private double calculateShipping(Cart cart) {
        // Simple shipping calculation based on item count
        // In a real application, this would be more complex
        if (cart.getItems().isEmpty()) {
            return 0;
        }

        int totalItems = 0;
        for (CartItem item : cart.getItems()) {
            totalItems += item.getQuantity();
        }

        // Free shipping for orders with 5 or more items
        if (totalItems >= 5) {
            return 0;
        }

        // Base shipping fee
        return 30000; // 30,000 VND
    }
}
