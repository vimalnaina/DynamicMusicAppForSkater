package com.capstone.service;

import com.capstone.dto.UserDTO;
import com.capstone.entity.User;

import java.io.IOException;
import java.util.List;

public interface UserService {
    User login(UserDTO userDTO);

    void save(UserDTO userDTO) throws IOException;

    List<User> getAllSkaters();
}
