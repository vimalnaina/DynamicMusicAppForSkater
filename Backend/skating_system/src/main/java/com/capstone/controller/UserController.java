package com.capstone.controller;

import com.amazonaws.services.polly.model.OutputFormat;
import com.capstone.common.BaseContext;
import com.capstone.common.SnowFlake;
import com.capstone.exception.BaseException;
import com.capstone.dto.UserDTO;
import com.capstone.entity.User;
import com.capstone.properties.JwtProperties;
import com.capstone.result.Result;
import com.capstone.service.UserService;
import com.capstone.util.JwtUtil;
import com.capstone.util.TTSUtil;
import com.capstone.vo.UserLoginVO;
import com.capstone.vo.UserSaveVO;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutionException;

@Api(tags = "skater relevant")
@RestController
@RequestMapping("/user")
@Slf4j
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private JwtProperties jwtProperties;

    @Autowired
    private RedisTemplate redisTemplate;

    @Autowired
    private KafkaController kafkaController;


    @PostMapping("/login")
    public Result<UserLoginVO> login(@RequestBody UserDTO userDTO){
        log.info("start user login");

        User user = userService.login(userDTO);

        //登录成功后，生成jwt令牌
        Map<String, Object> claims = new HashMap<>();
        claims.put("userId", user.getId());
        String token = JwtUtil.createJWT(
                jwtProperties.getAdminSecretKey(),
                jwtProperties.getAdminTtl(),
                claims);

        UserLoginVO userLoginVO = UserLoginVO.builder()
                .id(user.getId())
                .userName(user.getUserName())
                .token(token)
                .type(user.getType())
                .audio(user.getAudio())
                .build();

        return Result.success(userLoginVO);
    }


    @ApiOperation("sign up for the new user")
    @PostMapping("/save")
    //TODO need for kafka exception handler
    public Result<UserSaveVO> save(@RequestBody UserDTO userDTO) throws IOException, ExecutionException, InterruptedException {
        userService.save(userDTO);

        UserSaveVO userSaveVO = new UserSaveVO();

        UserLoginVO userLoginVO = login(userDTO).getData();

        //using kafka sent userAudioData to frontend
        Long userAudioId = userLoginVO.getAudio();

        byte[] audioData = (byte[]) redisTemplate.opsForValue().get(userAudioId.toString());

        BeanUtils.copyProperties(userLoginVO, userSaveVO);

        userSaveVO.setUserAudioData(audioData);

        kafkaController.sendUserAudio(userSaveVO);

        return Result.success(userSaveVO);
    }


    @PostMapping("/logout")
    @ApiOperation("user logout")
    public Result logout(){
        if(BaseContext.getCurrentId() == null){
            throw new BaseException("please log in first");
        }
        BaseContext.removeCurrentId();
        return Result.success("logout successful.");
    }



//    @GetMapping("/byh")
//    public Result getAudio() throws IOException {
//        TTSUtil ttsUtil = new TTSUtil();
//        SnowFlake snowFlake = new SnowFlake(1,1);
//        byte[] byhAudio = ttsUtil.getByteFile("Next player is byh", OutputFormat.Mp3);
//        Long audioId = snowFlake.nextId();
//        redisTemplate.opsForValue().set(audioId.toString(), byhAudio);
//        return Result.success(audioId);
//    }


    @GetMapping("allSkaters")
    public Result<List<User>> getAllSkaters(){
        List<User> users = userService.getAllSkaters();
        return Result.success(users);
    }
}
