package com.bqa.service;

import com.bqa.dao.UserDAO;
import com.bqa.model.User;

import java.util.List;

public class UserService {
    private UserDAO userDAO;
    
    public UserService() {
        this.userDAO = new UserDAO();
    }

    public User authenticate(String username, String password) {
        User user = userDAO.getUserByUsername(username);
        
        if (user != null && user.getPassword().equals(password)) {
            return user;
        }
        
        return null;
    }

    public boolean registerUser(User user) {
        if (userDAO.getUserByUsername(user.getUsername()) != null) {
            return false;
        }
        
        if (userDAO.getUserByEmail(user.getEmail()) != null) {
            return false;
        }
        
        user.setPassword(user.getPassword());
        
        if (user.getRole() == null || user.getRole().isEmpty()) {
            user.setRole("CUSTOMER");
        }
        
        if (user.getStatus() == 0) {
            user.setStatus(1);
        }
        
        return userDAO.addUser(user);
    }

    public User getUserById(int userId) {
        return userDAO.getUserById(userId);
    }

    public List<User> getAllUsers(String search, String role, String status, int offset, int limit) {
        return userDAO.getAllUsers(search, role, status, offset, limit);
    }

    public int getTotalUsers(String search, String role, String status) {
        return userDAO.getTotalUsers(search, role, status);
    }

    public boolean isUsernameExists(String username) {
        return userDAO.getUserByUsername(username) != null;
    }

    public boolean isEmailExists(String email) {
        return userDAO.getUserByEmail(email) != null;
    }

    public boolean isEmailExistsForOtherUser(String email, int userId) {
        User user = userDAO.getUserByEmail(email);
        return user != null && user.getUserId() != userId;
    }

    public boolean updateUser(User user) {
        // Get existing user
        User existingUser = userDAO.getUserById(user.getUserId());
        
        if (existingUser == null) {
            return false;
        }
        
        // Check if username is changed and already exists
        if (!existingUser.getUsername().equals(user.getUsername()) && 
            userDAO.getUserByUsername(user.getUsername()) != null) {
            return false;
        }
        
        // Check if email is changed and already exists
        if (!existingUser.getEmail().equals(user.getEmail()) && 
            userDAO.getUserByEmail(user.getEmail()) != null) {
            return false;
        }

        if (!user.getPassword().equals(existingUser.getPassword())
//            !BCrypt.checkpw(user.getPassword(), existingUser.getPassword()))
            )
        {
            user.setPassword(user.getPassword());
        }

        return userDAO.updateUser(user);
    }

    public boolean deleteUser(int userId) {
        return userDAO.deleteUser(userId);
    }

    public int getActiveCustomers() {
        return userDAO.getActiveCustomers();
    }

    public boolean insertUser(User user) {
        // Check if username or email already exists
        if (userDAO.getUserByUsername(user.getUsername()) != null) {
            return false; // Username exists
        }
        if (userDAO.getUserByEmail(user.getEmail()) != null) {
            return false; // Email exists
        }
        // Password should be pre-hashed if required or handled here
        // For simplicity, direct add like registerUser without some checks
        return userDAO.addUser(user);
    }
}
