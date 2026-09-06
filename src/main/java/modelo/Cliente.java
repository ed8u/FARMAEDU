package modelo;

public class Cliente {
    private int idCliente;
    private String dniRuc;
    private String nombresRsocial;
    private String email;
    private String telefono;
    private String direccion;

    public Cliente() {}

    // Getters y Setters
    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { this.idCliente = idCliente; }

    public String getDniRuc() { return dniRuc; }
    public void setDniRuc(String dniRuc) { this.dniRuc = dniRuc; }

    public String getNombresRsocial() { return nombresRsocial; }
    public void setNombresRsocial(String nombresRsocial) { this.nombresRsocial = nombresRsocial; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }

    public String getDireccion() { return direccion; }
    public void setDireccion(String direccion) { this.direccion = direccion; }
}