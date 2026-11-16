package pe.edu.utp.SistemaFarmaciaWeb.modelo;

import java.time.LocalDate;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class LoteMedicamento {

    private int idLote;
    private int idMedicamento;
    private String numeroLote;
    private LocalDate fechaVencimiento;
    private int stockActual;
    private LocalDateTime fechaIngreso;
    private boolean estado;

    private String codigoBarras;
    private String nombreMedicamento;
    private String concentracion;
    private String nombreLaboratorio;
    private int diasParaVencer;
    
    private int id; 
    private double precio;
}
