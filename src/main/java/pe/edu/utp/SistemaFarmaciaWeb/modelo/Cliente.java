package pe.edu.utp.SistemaFarmaciaWeb.modelo;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Cliente {

    private int idCliente;
    private String tipoDocumento; 
    private String dniRuc;
    private String nombresRsocial;
    private String email;
    private String telefono;
    private String direccion;
    private LocalDateTime fechaRegistro;
    private boolean estado;
}
