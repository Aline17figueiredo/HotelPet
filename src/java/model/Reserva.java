package model;

public class Login {
    private int id_login;
    private String login;
    private String senha;

    public Login() {}

    public Login(String login, String senha) {
        this.login = login;
        this.senha = senha;
    }

    public int getId_login() {
        return id_login;
    }

    public void setId_login(int id_login) {
        this.id_login = id_login;
    }

    public String getLogin() {
        return login;
    }

    public void setLogin(String login) {
        this.login = login;
    }

    public String getSenha() {
        return senha;
    }

    public void setSenha(String senha) {
        this.senha = senha;
    }
}
