package net.javaguide.login.bean;

import java.io.Serializable;

public class LoginBean implements Serializable {
	
	private static final long serialVersionUID = 1L;
	private String email;
	private String password;

	public String getUsername() {
		return email;
	}

	public void setUsername(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}
}
