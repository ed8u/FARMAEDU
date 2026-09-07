package pe.edu.utp.SistemaFarmaciaWeb.modelo;

import java.math.BigDecimal;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
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

    private BigDecimal precioCompraRef;
    private BigDecimal precioVenta;

    private int stockMinimo;
    private boolean recetaObligatoria;
    private boolean estado;

    // Datos auxiliares para vistas / joins
    private String nombrePrincipio;
    private String nombreForma;
    private String nombrePresentacion;
    private String nombreLaboratorio;
    private String nombreCategoria;
    private Integer stockTotal; // Suma acumulada del stock de sus lotes vigentes
}
