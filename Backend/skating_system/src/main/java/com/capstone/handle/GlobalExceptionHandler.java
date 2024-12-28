package com.capstone.handle;


import com.capstone.exception.BaseException;
import com.capstone.exception.UserNameAlreadyExistException;
import com.capstone.exception.UserNotLoginException;
import com.capstone.result.Result;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import javax.servlet.http.HttpServletResponse;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * 全局异常处理器，处理项目中抛出的业务异常
 */
@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    /**
     * 捕获业务异常
     * @param ex
     * @return
     */
    @ExceptionHandler
    public Result exceptionHandler(BaseException ex){
        log.error("异常信息：{}", ex.getMessage());
        return Result.error(ex.getMessage());
    }

//    /**
//     * 处理SQL异常
//     * @param ex
//     * @return
//     */
//    @ExceptionHandler
//    public Result exceptionHandler(SQLIntegrityConstraintViolationException ex){
//        //Duplicate entry 'zhangsan' for key 'employee.idx_username'
//        String message = ex.getMessage();
//        if(message.contains("Duplicate entry")){
//            String[] split = message.split(" ");
//            String username = split[2];
//            String msg = username + "已存在";
//            return Result.error(msg);
//        }else{
//            //未知错误
//            return Result.error(MessageConstant.UNKNOWN_ERROR);
//        }
//    }

    /**
     * deal with user no login exception
     * @param ex
     * @param response
     * @return
     */
    @ExceptionHandler
    public Result exceptionHandler(UserNotLoginException ex, HttpServletResponse response){
        log.info("please login first...");
        response.setStatus(401);
        return Result.error(ex.getMessage());
    }

    /**
     * deal with username already exist error
     * @param ex
     * @return
     */
    @ExceptionHandler
    public Result exceptionHandler(UserNameAlreadyExistException ex){
        return Result.error(ex.getMessage());
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<String> handleException(Exception ex) {
        // 日志记录异常
        Logger.getLogger(GlobalExceptionHandler.class.getName()).log(Level.SEVERE, ex.getMessage(), ex);
        // 返回适当的 HTTP 响应
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Internal Server Error: " + ex.getMessage());
    }

}
