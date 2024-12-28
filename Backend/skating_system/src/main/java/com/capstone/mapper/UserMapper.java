package com.capstone.mapper;

import com.capstone.entity.User;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface UserMapper {

    @Select("select * from capstone.user where user_name = #{userName}")
    User getByUsername(String userName);

    @Insert("insert into capstone.user(id, user_name, password, type, audio)" +
            "values " +
            "(#{id}, #{userName}, #{password}, #{type}, #{audio})")
    void insert(User user);

    @Select("select count(*) from capstone.user where user_name = #{userName}")
    int countByUserName(String userName);

    @Select("select capstone.user.user_name from capstone.user where id = #{id}")
    String getUsernameById(Long id);

    @Select("select capstone.user.* from user where type = 1")
    List<User> getAllSkaters();
}
