package com.laker.notes.easy.webshell.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class RouterController {
    @RequestMapping("/websshpage")
    public String websshpage(){
        return "webssh";
    }

    @RequestMapping("/login")
    public String client(){
        return "login";
    }

    @RequestMapping("/sftp")
    public String sftp(){
        return "sftp";
    }
}
