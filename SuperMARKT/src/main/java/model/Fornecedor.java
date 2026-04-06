package model;

public class Fornecedor {
	private int idFornecedor;
	private String tipoFornecedor;
	private String contacto;
	private String nif;
	
	
	public Fornecedor() {
		
	}	
	
	public Fornecedor(int idFornecedor, String tipoFornecedor, String contacto, String nif) {
		this.idFornecedor = idFornecedor;
		this.tipoFornecedor = tipoFornecedor;
		this.contacto = contacto;
		this.nif = nif;
	}

	public int getIdFornecedor() {
		return idFornecedor;
	}

	public void setIdFornecedor(int idFornecedor) {
		this.idFornecedor = idFornecedor;
	}

	public String getTipoFornecedor() {
		return tipoFornecedor;
	}

	public void setTipoFornecedor(String tipoFornecedor) {
		this.tipoFornecedor = tipoFornecedor;
	}

	public String getContacto() {
		return contacto;
	}

	public void setContacto(String contacto) {
		this.contacto = contacto;
	}

	public String getNif() {
		return nif;
	}

	public void setNif(String nif) {
		this.nif = nif;
	}
	
}
	
	

	