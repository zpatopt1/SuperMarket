package model;

public class PerdaStock {
    private Movimentos movimento;
    private Produto produto;
    private Local local;
    private int quantidade;
    private String motivo;

    public PerdaStock() {
    }

    public PerdaStock(Movimentos movimento, Produto produto, Local local, int quantidade, String motivo) {
        this.movimento = movimento;
        this.produto = produto;
        this.local = local;
        this.quantidade = quantidade;
        this.motivo = motivo;
    }

    public Movimentos getMovimento() {
        return movimento;
    }

    public void setMovimento(Movimentos movimento) {
        this.movimento = movimento;
    }

    public Produto getProduto() {
        return produto;
    }

    public void setProduto(Produto produto) {
        this.produto = produto;
    }

    public Local getLocal() {
        return local;
    }

    public void setLocal(Local local) {
        this.local = local;
    }

    public int getQuantidade() {
        return quantidade;
    }

    public void setQuantidade(int quantidade) {
        this.quantidade = quantidade;
    }

    public String getMotivo() {
        return motivo;
    }

    public void setMotivo(String motivo) {
        this.motivo = motivo;
    }
}