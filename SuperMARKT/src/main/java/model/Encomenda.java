package model;

import java.util.Date;

public class Encomenda {
    private Movimentos idMovimentos;
    private Fornecedor idFornecedor;
    private Local idLocal;
    private float valorTotal;
    private float custoEnvio;
    private Date dataPrevista;
    private Date dataChegada;

    public Encomenda() {

    }

    public Encomenda(Movimentos idMovimentos, Fornecedor idFornecedor, Local idLocal,
                     float valorTotal, float custoEnvio, Date dataPrevista, Date dataChegada) {
        this.idMovimentos = idMovimentos;
        this.idFornecedor = idFornecedor;
        this.idLocal = idLocal;
        this.valorTotal = valorTotal;
        this.custoEnvio = custoEnvio;
        this.dataPrevista = dataPrevista;
        this.dataChegada = dataChegada;
    }

    public Movimentos getIdMovimentos() {
        return idMovimentos;
    }

    public void setIdMovimentos(Movimentos idMovimentos) {
        this.idMovimentos = idMovimentos;
    }

    public Fornecedor getIdFornecedor() {
        return idFornecedor;
    }

    public void setIdFornecedor(Fornecedor idFornecedor) {
        this.idFornecedor = idFornecedor;
    }

    public Local getIdLocal() {
        return idLocal;
    }

    public void setIdLocal(Local idLocal) {
        this.idLocal = idLocal;
    }

    public float getValorTotal() {
        return valorTotal;
    }

    public void setValorTotal(float valorTotal) {
        this.valorTotal = valorTotal;
    }

    public float getCustoEnvio() {
        return custoEnvio;
    }

    public void setCustoEnvio(float custoEnvio) {
        this.custoEnvio = custoEnvio;
    }

    public Date getDataPrevista() {
        return dataPrevista;
    }

    public void setDataPrevista(Date dataPrevista) {
        this.dataPrevista = dataPrevista;
    }

    public Date getDataChegada() {
        return dataChegada;
    }

    public void setDataChegada(Date dataChegada) {
        this.dataChegada = dataChegada;
    }
}