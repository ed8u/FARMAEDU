package pe.edu.utp.SistemaFarmaciaWeb.modelo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Usuario {

    private int idUsuario;
    private String usuario;
    private String password;
    private String rol;
    private String nombresCompletos;
    private boolean estado;
}
