package modelo;

public class Medicamento {
    private int idMedicamento;
    private String codigoBarras;
    private String nombreComercial;
    private int idPrincipio;
    private int idForma;
    private String concentracion;
    private int idPresentacion;
    private int idLaboratorio;
    private int idCategoria;
    private boolean recetaObligatoria;
    private double precioCompraRef;
    private double precioVenta;
    private int stockMinimo;
    private boolean estado;
    
    // Variables auxiliares para mostrar los nombres en la tabla (no solo los IDs)
    private String nombrePrincipio;
    private String nombreForma;
    private String nombrePresentacion;
    private String nombreLaboratorio;
    private String nombreCategoria;

    public Medicamento() {}

    // Getters y Setters
    public int getIdMedicamento() { return idMedicamento; }
    public void setIdMedicamento(int idMedicamento) { this.idMedicamento = idMedicamento; }

    public String getCodigoBarras() { return codigoBarras; }
    public void setCodigoBarras(String codigoBarras) { this.codigoBarras = codigoBarras; }

    public String getNombreComercial() { return nombreComercial; }
    public void setNombreComercial(String nombreComercial) { this.nombreComercial = nombreComercial; }

    public int getIdPrincipio() { return idPrincipio; }
    public void setIdPrincipio(int idPrincipio) { this.idPrincipio = idPrincipio; }

    public int getIdForma() { return idForma; }
    public void setIdForma(int idForma) { this.idForma = idForma; }

    public String getConcentracion() { return concentracion; }
    public void setConcentracion(String concentracion) { this.concentracion = concentracion; }

    public int getIdPresentacion() { return idPresentacion; }
    public void setIdPresentacion(int idPresentacion) { this.idPresentacion = idPresentacion; }

    public int getIdLaboratorio() { return idLaboratorio; }
    public void setIdLaboratorio(int idLaboratorio) { this.idLaboratorio = idLaboratorio; }

    public int getIdCategoria() { return idCategoria; }
    public void setIdCategoria(int idCategoria) { this.idCategoria = idCategoria; }

    public boolean isRecetaObligatoria() { return recetaObligatoria; }
    public void setRecetaObligatoria(boolean recetaObligatoria) { this.recetaObligatoria = recetaObligatoria; }

    public double getPrecioCompraRef() { return precioCompraRef; }
    public void setPrecioCompraRef(double precioCompraRef) { this.precioCompraRef = precioCompraRef; }

    public double getPrecioVenta() { return precioVenta; }
    public void setPrecioVenta(double precioVenta) { this.precioVenta = precioVenta; }

    public int getStockMinimo() { return stockMinimo; }
    public void setStockMinimo(int stockMinimo) { this.stockMinimo = stockMinimo; }

    public boolean isEstado() { return estado; }
    public void setEstado(boolean estado) { this.estado = estado; }

    public String getNombrePrincipio() { return nombrePrincipio; }
    public void setNombrePrincipio(String nombrePrincipio) { this.nombrePrincipio = nombrePrincipio; }

    public String getNombreForma() { return nombreForma; }
    public void setNombreForma(String nombreForma) { this.nombreForma = nombreForma; }

    public String getNombrePresentacion() { return nombrePresentacion; }
    public void setNombrePresentacion(String nombrePresentacion) { this.nombrePresentacion = nombrePresentacion; }

    public String getNombreLaboratorio() { return nombreLaboratorio; }
    public void setNombreLaboratorio(String nombreLaboratorio) { this.nombreLaboratorio = nombreLaboratorio; }

    public String getNombreCategoria() { return nombreCategoria; }
    public void setNombreCategoria(String nombreCategoria) { this.nombreCategoria = nombreCategoria; }
}