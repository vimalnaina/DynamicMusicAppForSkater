package com.capstone.service.Impl;

import com.amazonaws.services.polly.model.OutputFormat;
import com.capstone.exception.BaseException;
import com.capstone.common.SnowFlake;
import com.capstone.dto.UserDTO;
import com.capstone.entity.User;
import com.capstone.exception.UserNameAlreadyExistException;
import com.capstone.mapper.UserMapper;
import com.capstone.service.UserService;
import com.capstone.util.TTSUtil;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.DigestUtils;

import java.io.IOException;
import java.util.List;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private RedisTemplate redisTemplate;

    @Override
    public User login(UserDTO userDTO) {
        String userName = userDTO.getUserName();
        String password = userDTO.getPassword();
        User user = userMapper.getByUsername(userName);

        if(user == null){
            throw new BaseException("Account not exist.");
        }
        String newPassword = DigestUtils.md5DigestAsHex(password.getBytes());

        if(!newPassword.equals(user.getPassword())){
            throw new BaseException("password error");
        }

        return user;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void save(UserDTO userDTO) throws IOException {
        String username = userDTO.getUserName();
        int count = userMapper.countByUserName(username);
        if(count > 0){
            throw new UserNameAlreadyExistException("This username already exist, please change another one...");
        }
        TTSUtil ttsUtil = new TTSUtil();
        SnowFlake snowFlake = new SnowFlake(1,1);
        User user = new User();
        //copy param from userDTO to user
        BeanUtils.copyProperties(userDTO, user);
        //using snowflake generate userId
        user.setId(snowFlake.nextId());
        //MD5 for password
        user.setPassword(DigestUtils.md5DigestAsHex(userDTO.getPassword().getBytes()));

        //generate user info audio
        Long audioId = snowFlake.nextId();
        String message = "Next player is" + user.getUserName();
        byte[] userAudio = ttsUtil.getByteFile(message, OutputFormat.Mp3);
        redisTemplate.opsForValue().set(audioId.toString(), userAudio);

        user.setAudio(audioId);
        userMapper.insert(user);
    }

    @Override
    public List<User> getAllSkaters() {
        List<User> users = userMapper.getAllSkaters();
        return users;
    }
}
