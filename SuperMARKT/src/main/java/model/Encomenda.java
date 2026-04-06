package model;

public class Encomenda {
	private Movimentos idMovimentos;
	private Fornecedor idFornecedor;
	private Local idLocal;
	
	public Encomenda() {
		
	}
	
	public Encomenda(Movimentos idMovimentos, Fornecedor idFornecedor, Local idLocal) {
		this.idMovimentos = idMovimentos;
		this.idFornecedor = idFornecedor;
		this.idLocal = idLocal;
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

}