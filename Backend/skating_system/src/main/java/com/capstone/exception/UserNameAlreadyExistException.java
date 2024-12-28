package com.capstone.exception;

public class UserNameAlreadyExistException extends BaseException{
    public UserNameAlreadyExistException(){}

    public UserNameAlreadyExistException(String msg){
        super(msg);
    }
}
