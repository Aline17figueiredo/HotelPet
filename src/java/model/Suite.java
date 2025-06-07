package model;

public class Suite {
    private int id;
    private String nome;
    private int capacidade;
    private float valor;

    // Construtores
    public Suite() {}

    public Suite(String nome, int capacidade, float valor) {
        this.nome = nome;
        this.capacidade = capacidade;
        this.valor = valor;
    }

    public Suite(int id, String nome, int capacidade, float valor) {
        this.id = id;
        this.nome = nome;
        this.capacidade = capacidade;
        this.valor = valor;
    }

    // Getters e Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public int getCapacidade() {
        return capacidade;
    }

    public void setCapacidade(int capacidade) {
        this.capacidade = capacidade;
    }

    public float getValor() {
        return valor;
    }

    public void setValor(float valor) {
        this.valor = valor;
    }
}
