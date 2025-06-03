package com.bqa.servlet;

import com.bqa.model.*;
import com.bqa.service.CartService;
import com.bqa.service.OrderService;
import com.bqa.service.productServiece;
import com.bqa.service.UserService;
import com.bqa.util.VNPayUtil;
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
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

/**
 * CheckoutServlet handles the checkout process for customers
 */
@WebServlet("/checkout/*")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CartService cartService;
    private OrderService orderService;
    private productServiece productServiece;

    public void init() {
        cartService = new CartService();
        orderService = new OrderService();
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
                case "/process":
                    processCheckout(request, response);
                    break;
                case "/success":
                    showSuccess(request, response);
                    break;
                case "/confirm":
                    showConfirm(request, response);
                    break;
                case "/vnpay_return":
                    processVNPayReturn(request, response);
                    break;
                default:
                    showCheckout(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void showCheckout(HttpServletRequest request, HttpServletResponse response)
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

        double total = subtotalDecimal.doubleValue();

        // Set attributes for JSP
        request.setAttribute("cart", cart); // The main cart object
        request.setAttribute("cart_items", cart_items_for_jsp); // The list of items from the cart
        request.setAttribute("products", products_for_jsp);     // Corresponding product details
        request.setAttribute("variant", variants_for_jsp);    // Variant details (with noted issue)

        // Attributes for the summary section in cart.jsp
        request.setAttribute("cartTotal", subtotalDecimal); // Maps to ${cartTotal}
        request.setAttribute("finalTotal", total);          // Maps to ${finalTotal}
        
        // Forward to checkout page
        RequestDispatcher dispatcher = request.getRequestDispatcher("/checkout.jsp");
        dispatcher.forward(request, response);
    }

    private void processCheckout(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        HttpSession session = request.getSession();
        
        // Check if user is logged in
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Get cart from session
        Cart cart = (Cart) session.getAttribute("cart");

        // Get form data
        String fullName = request.getParameter("shippingName");
        String email = request.getParameter("shippingEmail");
        String phone = request.getParameter("shippingPhone");
        String address = request.getParameter("shippingAddress");

        String city = request.getParameter("shippingProvince");
        String district = request.getParameter("shippingDistrict");
        String ward = request.getParameter("shippingWard");

        String paymentMethod = request.getParameter("paymentMethod");
        String notes = request.getParameter("note");
        
        // Validate required fields
        if (fullName == null || fullName.isEmpty() ||
            phone == null || phone.isEmpty() || address == null || address.isEmpty() ||
            city == null || city.isEmpty() || district == null || district.isEmpty() ||
            ward == null || ward.isEmpty() || paymentMethod == null || paymentMethod.isEmpty()) {
            
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin giao hàng");
            showCheckout(request, response);
            return;
        }
        
        // Create order object
        Order order = new Order();
        order.setUserId(user.getUserId());
        order.setShippingName(fullName);
        order.setShippingEmail(email);
        order.setShippingPhone(phone);
        order.setShippingAddress(address + ", " + ward + ", " + district + ", " + city);
        order.setPaymentMethod(paymentMethod);
        order.setNote(notes);
        order.setOrderStatus("pending");
        order.setOrderDate(new Timestamp(new Date().getTime()));
        
        // Calculate order totals
        BigDecimal orderSubtotalDecimal = BigDecimal.ZERO;
        for (CartItem item : cart.getItems()) {
            orderSubtotalDecimal = orderSubtotalDecimal.add(item.getPrice().multiply(new BigDecimal(item.getQuantity())));
        }
        order.setTotalAmount(orderSubtotalDecimal);

        if(paymentMethod.equals("COD")){
            // Save order to session for confirmation
            session.setAttribute("pendingOrder", order);
            
            // Create order items
            List<OrderItem> orderItems = orderService.createOrderItemsFromCart(cart);
            session.setAttribute("pendingOrderItems", orderItems);
            orderService.createOrder(order, orderItems);
            
            // Update product quantities
            updateProductQuantities(cart.getItems());
            
            cartService.clearCart(cart.getCartId());
            // Forward to order confirmation page
            RequestDispatcher dispatcher = request.getRequestDispatcher("/checkout-success.jsp");
            dispatcher.forward(request, response);
        }
        else if(paymentMethod.equals("VNPAY")){
            // Save order to session for confirmation
            session.setAttribute("pendingOrder", order);

            // Create order items
            List<OrderItem> orderItems = orderService.createOrderItemsFromCart(cart);
            session.setAttribute("pendingOrderItems", orderItems);
            order.setOrderId(orderService.createOrder(order, orderItems));

            // Create VNPay payment URL
            String paymentUrl = VNPayUtil.createPaymentUrl(request,
                String.valueOf(order.getOrderId()),
                    orderSubtotalDecimal.longValue());

            // Redirect to VNPay payment page
            response.sendRedirect(paymentUrl);
        }
    }

    private void processVNPayReturn(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        // Get all parameters from VNPay return URL
        Map<String, String[]> vnpParams = request.getParameterMap();
        Map<String, String> vnpParamsMap = new HashMap<>();
        
        for (String key : vnpParams.keySet()) {
            String[] values = vnpParams.get(key);
            if (values != null && values.length > 0) {
                vnpParamsMap.put(key, values[0]);
            }
        }

        String vnp_ResponseCode = vnpParamsMap.get("vnp_ResponseCode");
        String vnp_TransactionNo = vnpParamsMap.get("vnp_TransactionNo");
        String vnp_OrderInfo = vnpParamsMap.get("vnp_OrderInfo");
        String vnp_Amount = vnpParamsMap.get("vnp_Amount");

        // Get pending order from session
        Order order = (Order) session.getAttribute("pendingOrder");
        List<OrderItem> orderItems = (List<OrderItem>) session.getAttribute("pendingOrderItems");

        if (order != null && orderItems != null) {
            if ("00".equals(vnp_ResponseCode)) {
                // Payment successful
                order.setPaymentStatus("PAID");
                order.setOrderStatus("PROCESSING");

                // Save order to database
                int orderId = order.getOrderId() ;
                if (orderId > 0) {
                    // Update product quantities
                    updateProductQuantities(cart.getItems());
                    
                    cartService.clearCart(cart.getCartId());
                    session.removeAttribute("cart");
                    session.removeAttribute("pendingOrder");
                    session.removeAttribute("pendingOrderItems");
                    orderService.updateOrderStatus(orderId, "pending");
                    orderService.updatePaymentStatus(orderId, "PAID");

                    // Set success message
                    session.setAttribute("message", "Thanh toán thành công! Cảm ơn bạn đã mua hàng.");
                        // Redirect to success page
                    response.sendRedirect(request.getContextPath() + "/checkout/success");
                    return;
                }
            }
        }
        
        // If we get here, something went wrong
        session.setAttribute("error", "Thanh toán không thành công. Vui lòng thử lại sau.");
        response.sendRedirect(request.getContextPath() + "/checkout");
    }

    private void updateProductQuantities(List<CartItem> cartItems) {
        if (cartItems != null) {
            for (CartItem item : cartItems) {
                if (item.getVariantId() != null) {
                    // Get current variant quantity
                    List<Map<String, String>> variants = productServiece.getProductVariantById(item.getProductId());
                    for (Map<String, String> variant : variants) {
                        if (variant.get("variant_id").equals(String.valueOf(item.getVariantId()))) {
                            int currentQuantity = Integer.parseInt(variant.get("quantity"));
                            int newQuantity = currentQuantity - item.getQuantity();
                            if (newQuantity >= 0) {
                                // Update variant quantity
                                productServiece.editProductVariant(
                                    item.getVariantId(),
                                    variant.get("size"),
                                    variant.get("color"),
                                    newQuantity
                                );
                            }
                            break;
                        }
                    }
                }
            }
        }
    }

    private void showSuccess(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {

        RequestDispatcher dispatcher = request.getRequestDispatcher("/checkout-success.jsp");
        dispatcher.forward(request, response);
    }

    private void showConfirm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {

        RequestDispatcher dispatcher = request.getRequestDispatcher("/checkout-confirm.jsp");
        dispatcher.forward(request, response);
    }
}
